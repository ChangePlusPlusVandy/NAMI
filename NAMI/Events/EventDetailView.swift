//
//  EventDetailView.swift
//  NAMI
//
//  Created by Zachary Tao on 11/10/24.
//

import SwiftUI

struct EventDetailView: View {
    @Environment(EventsViewRouter.self) var eventsViewRouter
    @Environment(HomeScreenRouter.self) var homeScreenRouter
    var event: Event
    var revealLocation = false // Hide event addresses or Zoom links until users register.
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(event.title)
                        .font(.title.bold())

                    eventDateFormatted()
                        .foregroundStyle(.secondary)

                    HStack {
                        EventCategoryCapsule(eventCategory: event.eventCategory)
                        MeetingModeCapsule(meetingMode: event.meetingMode)
                    }
                }
                .padding(.top, 15)

                CachedAsyncImage(url: event.imageURL)

                if !event.about.isEmpty {
                    Text(event.about)
                        .padding(.vertical, 15)
                }

                VStack(alignment: .leading, spacing: 20) {
                    if !event.leaderName.isEmpty, !event.leaderPhoneNumber.isEmpty {
                        VStack(alignment: .leading) {

                            Text("Session Leader:")
                                .font(.headline.bold())
                                .padding(.vertical, 3)

                            Text(event.leaderName)
                            Text(event.leaderPhoneNumber)
                        }
                    }

                    if !event.eventSeries.isEmpty {
                        VStack(alignment: .leading) {
                            Text("Event Series")
                                .font(.headline.bold())
                                .padding(.vertical, 3)

                            Text(event.eventSeries)
                        }
                    }

                    meetingLocation
                }
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(.footnote)
        }
        .navigationTitle("")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                if UserManager.shared.isAdmin() {
                    Button("Edit") {
                        eventsViewRouter.navigate(to: .eventUpdateView(event: event))
                    }
                }
            }
        }
    }

    @ViewBuilder
    private var meetingLocation: some View {
        VStack(alignment: .leading) {
            Text("Location:")
                .font(.headline.bold())
                .padding(.vertical, 3)
            if revealLocation {
                switch event.meetingMode {
                case .inPerson(let location):
                    if !location.isEmpty {
                        Menu {
                            Button("Open in Apple Maps") {
                                openAddressInMap(address: location)
                            }
                            Button("Open in Google Maps") {
                                openAddressInGoogleMap(address: location)
                            }
                            Button("Copy Address to Clipboard") {
                                UIPasteboard.general.string = location
                            }
                        } label: {
                            HStack{
                                Text(location).foregroundStyle(.blue)
                                Image(systemName: "mappin.and.ellipse")
                            }
                        }
                    } else {
                        Text("N/A")
                    }

                case .virtual(let link):
                    if !link.isEmpty {
                        HStack {
                            if let url = URL(string: link) {
                                Menu {
                                    Button("Open in Safari") {
                                        UIApplication.shared.open(url)
                                    }
                                    Button("Copy Link to Clipboard") {
                                        UIPasteboard.general.string = link
                                    }
                                } label: {
                                    Text(link).foregroundStyle(.blue)
                                }
                            }
                        }
                    } else {
                        Text("N/A")
                    }
                }
            } else {
                Text("Event address/link will be provided once registered")
                    .foregroundStyle(.gray)
            }
        }
    }

    func eventDateFormatted() -> some View {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return Text("\(formatter.string(from: event.startTime)),  \(formatEventDurationWithTimeZone(startTime: event.startTime, endTime: event.endTime))")
    }
}

#Preview {
    EventDetailView(event: Event.dummyEvent)
        .environment(EventsViewRouter())
        .environment(HomeScreenRouter())
}
