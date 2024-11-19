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
                gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.white]),
                startPoint: .top,
                endPoint: .bottom
            ).ignoresSafeArea(.all)

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text(event.title)
                            .franklinGothic(.bold, 34)
                        Text("\(formattedDate(event.startTime))")
                            .proximaNova(.light, 15)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 20)


                    VStack(alignment: .leading) {
                        Text("Session Leader/s:")
                            .proximaNova(.regular, 17)

                        Text(sessionLeader)
                            .proximaNova(.light, 17)
                            .foregroundStyle(.secondary)

                        Text(contact)
                            .proximaNova(.light, 17)
                            .foregroundStyle(.secondary)
                    }


                    meetingModeSection

                    VStack(alignment: .leading) {
                        Text("About")
                            .proximaNova(.regular, 17)
                        Text(event.about)
                            .proximaNova(.light, 17)
                            .foregroundStyle(.secondary)
                    }

                    VStack(alignment: .leading) {
                        Text("Series:")
                            .proximaNova(.regular, 17)
                        Text(series)
                            .proximaNova(.light, 17)
                            .foregroundColor(.secondary)
                    }

                    VStack(alignment: .leading) {
                        Text("Event Categories:")
                            .proximaNova(.regular, 17)
                        Text(eventCategories)
                            .proximaNova(.light, 17)
                            .foregroundStyle(.secondary)
                    }
                }.padding(.horizontal, 20)
            }
        }
        .background(LinearGradient(
            gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.white]),
            startPoint: .top,
            endPoint: .bottom
        ))
        .toolbar(.hidden, for: .tabBar)
        .navigationTitle("")
    }

    @ViewBuilder
    private var meetingModeSection: some View {
        VStack(alignment: .leading) {
            Text("Meeting Mode:")
                .proximaNova(.regular, 17)
            switch event.meetingMode {
            case .inPerson:
                Text("In Person")
                    .proximaNova(.light, 17)
                    .foregroundStyle(.secondary)
            case .virtual(let link):
                Text("Virtual")
                    .proximaNova(.light, 17)
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
