//
//  EventDetailView.swift
//  NAMI
//
//  Created by Zachary Tao on 11/10/24.
//

import SwiftUI

struct EventDetailView: View {
    @Environment(EventsViewRouter.self) var eventsViewRouter
    var event: Event
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 10) {
                    Text(event.title)
                        .font(.title.bold())
                    Text("\(formattedDate(event.startTime))")
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 15)

                VStack(alignment: .leading) {
                    Text("Session Leader/s:")
                        .font(.title3.bold())
                        .padding(.vertical, 3)

                    if event.leaderName.isEmpty, event.leaderPhoneNumber.isEmpty {
                        Text("N/A")
                    }
                    Text(event.leaderName)
                    Text(event.leaderPhoneNumber)
                }

                meetingModeSection

                VStack(alignment: .leading) {
                    Text("About:")
                        .font(.title3.bold())
                        .padding(.vertical, 3)
                    Text(event.about)
                }

                VStack(alignment: .leading) {
                    Text("Event Category:")
                        .font(.title3.bold())
                        .padding(.vertical, 3)
                    Text(event.eventCategory.rawValue)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(.footnote)
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .navigationTitle("")
    }

    @ViewBuilder
    private var meetingModeSection: some View {
        VStack(alignment: .leading) {
            Text("Meeting Mode:")
                .font(.title3.bold())
                .padding(.vertical, 3)
            switch event.meetingMode {
            case .inPerson:
                Text("In Person")
            case .virtual(let link):
                Text("Virtual")

                HStack {
                    if let url = URL(string: link) {
                        Link(link, destination: url)
                            .foregroundStyle(.blue)

                        Button {
                            UIPasteboard.general.string = link
                        } label: {
                            Image(systemName: "doc.on.doc")
                        }
                    }
                }
            }
        }
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

#Preview {
    EventDetailView(event: Event.dummyEvent)
        .environment(EventsViewRouter())
}
