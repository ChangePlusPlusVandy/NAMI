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
    var sessionLeader: String = "Amy Cliff"
    var contact: String = "909-000-1827"
    var series: String = "Ex: Family-To-Family Class- In-Person"
    var eventCategories: String = "Ex: Education, NAMI \nFamily-to-Family, NAMI \nWilliamson and Maury County TN"
    var body: some View {
        ZStack{
            LinearGradient(
                gradient: Gradient(colors: [Color.NAMIDarkBlue.opacity(0.5), Color.NAMITealBlue.opacity(0.5)]),
                startPoint: .top,
                endPoint: .bottom
            ).ignoresSafeArea(.all)

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text(event.title)
                            .font(.largeTitle.bold())
                        Text("\(formattedDate(event.startTime))")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 20)


                    VStack(alignment: .leading) {
                        Text("Session Leader/s:")
                            .font(.headline)

                        Text(sessionLeader)
                            .font(.body)
                            .foregroundStyle(.secondary)

                        Text(contact)
                            .font(.body)
                            .foregroundStyle(.secondary)
                    }


                    meetingModeSection

                    VStack(alignment: .leading) {
                        Text("About")
                            .font(.headline)
                        Text(event.about)
                            .font(.body)
                            .foregroundStyle(.secondary)
                    }

                    VStack(alignment: .leading) {
                        Text("Series:")
                            .font(.headline)
                        Text(series)
                            .font(.body)
                            .foregroundColor(.secondary)
                    }

                    VStack(alignment: .leading) {
                        Text("Event Categories:")
                            .font(.headline)
                        Text(eventCategories)
                            .font(.body)
                            .foregroundStyle(.secondary)
                    }
                }.padding(.horizontal, 20)
            }
        }
        .toolbar(.hidden, for: .tabBar)
        .navigationTitle("")
    }

    @ViewBuilder
    private var meetingModeSection: some View {
        VStack(alignment: .leading) {
            Text("Meeting Mode:")
                .font(.headline)
            switch event.meetingMode {
            case .inPerson:
                Text("In Person")
                    .font(.body)
                    .foregroundStyle(.secondary)
            case .virtual(let link):
                Text("Virtual")
                    .font(.body)
                    .foregroundStyle(.secondary)

                HStack {
                    if let url = URL(string: link) {
                        Link(link, destination: url)
                            .foregroundStyle(.blue)

                        Button {
                            UIPasteboard.general.string = link
                        } label: {
                            Image(systemName: "doc.on.doc")
                                .foregroundStyle(.secondary)
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
