//
//  EventsView.swift
//  NAMI
//
//  Created by Zachary Tao on 11/10/24.
//

import SwiftUI
import FirebaseFirestore

struct EventsView: View {
    @State var eventsViewRouter = EventsViewRouter()
    @Environment(TabsControl.self) var tabVisibilityControls

    @State var searchText: String = ""
    @State var selectedMeetingMode: MeetingMode?
    @State var selectedCategory: EventCategory?

    @FirestoreQuery(collectionPath: "events", predicates: []) var events: [Event]

    var filteredEvents: [Event] {
        events.filter { event in
            (selectedCategory == nil || event.eventCategory == selectedCategory) &&
            (searchText.isEmpty || event.title.localizedCaseInsensitiveContains(searchText) || event.about.localizedCaseInsensitiveContains(searchText)) &&
            (selectedMeetingMode == nil || event.meetingMode.displayName == selectedMeetingMode?.displayName)
        }
    }
    var body: some View {
        NavigationStack(path: $eventsViewRouter.navPath) {
            VStack {
                List {
                    eventsMenuFilter
                        .listRowSeparator(.hidden, edges: .all)
                    ForEach(filteredEvents) {event in
                        EventCardView(event: event)
                            .environment(eventsViewRouter)
                            .listRowSeparator(.hidden, edges: .all)
                            .swipeActions(edge: .trailing, allowsFullSwipe: false){
                                Button("", systemImage: "calendar.badge.plus") {}
                                    .tint(Color.NAMIDarkBlue)
                            }
                            .onTapGesture {
                                tabVisibilityControls.makeHidden()
                                eventsViewRouter.navigate(to: .eventDetailView(event: event))
                            }
                    }
                }
                .listStyle(.plain)
                .scrollIndicators(.hidden)
                .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .automatic))
                .refreshable {}
            }
            .navigationTitle("Events")
            .navigationDestination(for: EventsViewRouter.Destination.self) { destination in
                switch destination {
                case .eventDetailView(let event):
                    EventDetailView(event: event)
                        .environment(eventsViewRouter)
                case .eventCreationView:
                    EventCreationView()
                        .environment(eventsViewRouter)
                        .environment(HomeScreenRouter())
                }
            }
            .onChange(of: eventsViewRouter.navPath) {
                if eventsViewRouter.navPath.isEmpty {
                    tabVisibilityControls.makeVisible()
                }
            }
            .toolbar {
                if UserManager.shared.userType == .admin {
                    ToolbarItem(placement: .topBarTrailing){
                        Button {
                            eventsViewRouter.navigate(to: .eventCreationView)
                            tabVisibilityControls.makeHidden()
                        } label: {
                            Image(systemName: "plus.app")
                        }
                    }
                }
            }
        }
    }

    var eventsMenuFilter: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                Menu{
                    let selected = Binding(
                        get: { selectedCategory },
                        set: {
                            selectedCategory = $0 == selectedCategory ? nil : $0
                        }
                    )

                    Picker("Category", selection: selected) {
                        ForEach(EventCategory.allCases){ category in
                            Text(category.rawValue).tag(category)
                        }
                    }
                } label: {
                    Label(selectedCategory?.rawValue ?? "All Categories", systemImage: "chevron.down")
                }

                Menu {
                    let selected = Binding(
                        get: { selectedMeetingMode },
                        set: { selectedMeetingMode = $0 == selectedMeetingMode ? nil : $0 }
                    )
                    Picker("Mode", selection: selected) {
                        Label("Virtual", systemImage: "laptopcomputer.and.iphone").tag(MeetingMode.virtual(link: ""))
                        Label("In Person", systemImage: "person.3").tag(MeetingMode.inPerson(location: ""))
                    }
                } label: {
                    Label(selectedMeetingMode?.displayName ?? "All Modes", systemImage: "chevron.down")
                }
            }
            .labelStyle(CustomFilterLabelStyle())
            .buttonStyle(.bordered)
            .buttonBorderShape(.capsule)
        }
    }
}

#Preview {
    EventsView()
        .environment(TabsControl())
}
