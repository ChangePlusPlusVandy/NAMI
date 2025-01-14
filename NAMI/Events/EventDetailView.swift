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
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 10) {
                    Text(event.title)
                        .font(.title.bold())
                    eventDateFormatted()
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 15)

                CachedAsyncImage(url: event.imageURL)

                Text(event.about)

                VStack(alignment: .leading) {
                    Text("Session Leader:")
                        .font(.headline.bold())
                        .padding(.vertical, 3)

                    if event.leaderName.isEmpty, event.leaderPhoneNumber.isEmpty {
                        Text("N/A")
                    } else {
                        Text(event.leaderName)
                        Text(event.leaderPhoneNumber)
                    }
                }

                VStack(alignment: .leading) {
                    Text("Event Category:")
                        .font(.headline.bold())
                        .padding(.vertical, 3)
                    Text(event.eventCategory.rawValue)
                }

                meetingModeSection
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(.footnote)
        }
        .navigationTitle("")
    }

    @ViewBuilder
    private var meetingModeSection: some View {
        VStack(alignment: .leading) {
            Text("Location:")
                .font(.headline.bold())
                .padding(.vertical, 3)
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
                }
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
