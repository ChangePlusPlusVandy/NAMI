//
//  EventsView.swift
//  NAMI
//
//  Created by Zachary Tao on 11/10/24.
//

import SwiftUI

struct EventsView: View {
    @State var eventsManager = EventsManager()
    @State var eventsViewRouter = EventsViewRouter()

    var body: some View {
        NavigationStack(path: $eventsViewRouter.navPath) {
            VStack {
                eventsMenuFilter
                List(eventsManager.filteredEvents) { event in
                    EventCardView(event: event)
                        .environment(eventsViewRouter)
                        .listRowSeparator(.hidden, edges: .all)
                        .swipeActions(edge: .trailing, allowsFullSwipe: false){
                            Button("", systemImage: "calendar.badge.plus") {}
                                .tint(Color.NAMIDarkBlue)
                        }
                        .onTapGesture {
                            eventsViewRouter.navigate(to: .eventDetailView(event: event))
                        }
                }
                .listStyle(.plain)
                .scrollIndicators(.hidden)
                .searchable(text: $eventsManager.searchText, placement: .navigationBarDrawer(displayMode: .always))
                .refreshable {

                }
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
                        .toolbar(.hidden, for: .tabBar)
                }
            }
            .toolbar {
                if UserManager.shared.userType == .admin {
                    ToolbarItem(placement: .topBarTrailing){
                        Button {
                            eventsViewRouter.navigate(to: .eventCreationView)
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
                        get: { eventsManager.selectedCategory },
                        set: {
                            self.eventsManager.selectedCategory = $0 == self.eventsManager.selectedCategory ? nil : $0
                        }
                    )

                    Picker("Category", selection: selected) {
                        ForEach(EventCategory.allCases){ category in
                            Text(category.rawValue).tag(category)
                        }
                    }
                } label: {
                    Label(eventsManager.selectedCategory?.rawValue ?? "All Categories", systemImage: "chevron.down")
                }

                Menu {
                    let selected = Binding(
                        get: { eventsManager.selectedMeetingMode },
                        set: { self.eventsManager.selectedMeetingMode = $0 == self.eventsManager.selectedMeetingMode ? nil : $0 }
                    )
                    Picker("Mode", selection: selected) {
                        Label("Virtual", systemImage: "laptopcomputer.and.iphone").tag(MeetingMode.virtual(link: ""))
                        Label("In Person", systemImage: "person.3").tag(MeetingMode.inPerson(location: ""))
                    }
                } label: {
                    Label(eventsManager.selectedMeetingMode?.displayName ?? "All Modes", systemImage: "chevron.down")
                }
            }
            .labelStyle(CustomFilterLabelStyle())
            .padding(.horizontal)
            .buttonStyle(.bordered)
            .buttonBorderShape(.capsule)
        }
    }
}

#Preview {
    EventsView()
}
