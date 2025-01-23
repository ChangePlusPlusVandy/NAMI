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

    @State var showRegisterConfirmation = false
    @State var showCancelConfirmation = false
    @State var showSuccessSheet = false

    var event: Event
    // Hide event addresses or Zoom links until users register.
    //var isRegistered = false
    var isRegistered: Bool {
        if let registeredEvents = UserManager.shared.currentUser?.registeredEventsIds {
            return registeredEvents.contains(event.id ?? "")
        } else {
            return false
        }
    }

    var body: some View {
        ZStack {
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
                .padding(.horizontal, 30)
                .padding(.bottom, 20)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.footnote)
            }

            if isRegistered {
                cancelButton
            } else {
                registerButton
            }

            if showSuccessSheet {
                EventRegisteredSuccessSheet(isPresented: $showSuccessSheet)
            }

        }
        .sensoryFeedback(.impact(weight: .heavy), trigger: showSuccessSheet)
        .confirmationDialog(
            "Are you sure you want to register for this event?",
            isPresented: $showRegisterConfirmation)
        {
            Button("Register") {
                EventsManager.shared.registerUserForEvent(eventId: event.id ?? "", userId: UserManager.shared.userID)
                withAnimation(.snappy) { showSuccessSheet = true }
            }
        }
        .confirmationDialog(
            "Are you sure you want to cancel registration for this event?",
            isPresented: $showCancelConfirmation,
            titleVisibility: .visible
        ) {
            Button("Cancel Registration", role: .destructive) {
                if let targetEventId = event.id {
                    EventsManager.shared.cancelRegistrationForEvent(eventId: targetEventId, userId: UserManager.shared.userID)
                    eventsViewRouter.navigateToRoot()
                    homeScreenRouter.navigateToRoot()
                }
            }
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

    var registerButton: some View {
        Button {
            showRegisterConfirmation = true
        } label: {
            Label("Register", systemImage: "calendar.badge.plus")
                .foregroundColor(.white)
                .padding()
                .background(Color.NAMIDarkBlue)
                .cornerRadius(20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
        .shadow(radius: 1)
        .padding(30)
        .padding(.vertical, 20)
        .ignoresSafeArea()
    }

    var cancelButton: some View {
        Button {
            showCancelConfirmation = true
        } label: {
            Label("Cancel", systemImage: "calendar.badge.minus")
                .foregroundColor(.white)
                .padding()
                .background(Color.NAMITealBlue)
                .cornerRadius(20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
        .shadow(radius: 1)
        .padding(30)
        .padding(.vertical, 20)
        .ignoresSafeArea()
    }

    @ViewBuilder
    private var meetingLocation: some View {
        VStack(alignment: .leading) {
            Text("Location:")
                .font(.headline.bold())
                .padding(.vertical, 3)
            if isRegistered {
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
