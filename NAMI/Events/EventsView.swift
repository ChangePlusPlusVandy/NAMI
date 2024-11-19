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
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("Events")
                        .franklinGothic(.regular, 32)
                        .padding(15)
                }
            }
            .navigationDestination(for: EventsViewRouter.Destination.self) { destination in
                switch destination {
                case .eventDetailView(let event):
                    EventDetailView(event: event)
                        .environment(eventsViewRouter)
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
                    let selectedCategory = eventsManager.selectedCategory
                    Label(selectedCategory == nil ? "Category" : selectedCategory!.rawValue, systemImage: "chevron.down")
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
                    let selectedMeetingMode = eventsManager.selectedMeetingMode
                    Label(selectedMeetingMode == nil ? "Mode" : selectedMeetingMode!.displayName, systemImage: "chevron.down")
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
