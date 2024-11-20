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
//            LinearGradient(
//                gradient: Gradient(colors: [Color.NAMIDarkBlue.opacity(0.2), Color.NAMITealBlue.opacity(0.2)]),
//                startPoint: .top,
//                endPoint: .bottom
//            ).ignoresSafeArea(.all)

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text(event.title)
                            .font(.largeTitle.bold())
                        Text("\(formattedDate(event.startTime))")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 20)


                    VStack(alignment: .leading) {
                        Text("Session Leader/s:")
                            .font(.title3.bold())
                            .padding(.vertical, 3)

                        Text(sessionLeader)

                        Text(contact)
                    }


                    meetingModeSection

                    VStack(alignment: .leading) {
                        Text("About:")
                            .font(.title3.bold())
                            .padding(.vertical, 3)
                        Text(event.about)
                    }

                    VStack(alignment: .leading) {
                        Text("Series:")
                            .font(.title3.bold())
                            .padding(.vertical, 3)
                        Text(series)
                    }

                    VStack(alignment: .leading) {
                        Text("Event Categories:")
                            .font(.title3.bold())
                            .padding(.vertical, 3)
                        Text(eventCategories)
                    }
                }.padding(.horizontal, 20)
            }
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
