//
//  EventsView.swift
//  NAMI
//
//  Created by Zachary Tao on 11/10/24.
//

import SwiftUI
import FirebaseFirestore

struct EventsView: View {
    @Environment(TabsControl.self) var tabVisibilityControls

    @State var eventsViewRouter = EventsViewRouter()
    @State var searchText: String = ""
    @State var selectedMeetingMode: MeetingMode?
    @State var selectedCategory: EventCategory?
    @State private var calendarManager = CalendarManager()

    @FirestoreQuery(collectionPath: "events",
                    predicates: [.order(by: "startTime", descending: false)],
                    animation: .default) var events: [Event]

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
                CalendarDisplaySelectionButton()
                    .padding(.horizontal)
                switch calendarManager.viewOption {
                case .calendar:
                    Group {
                        Group {
                            CalendarSelectionHeader()
                                .padding(.vertical, 8)
                            CalendarGrid(events: events)
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)

                        CalendarDayDetailView(
                            selectedDate: calendarManager.selectedDate,
                            events: events
                        )
                    }
                    .transition(.move(edge: .trailing))
                case .list:
                    Group {
                        eventsMenuFilter
                            .padding(.horizontal)
                            .padding(.top, 8)
                        List(filteredEvents) { event in
                            CustomEventsCardView(event: event)
                                .onTapGesture {
                                    tabVisibilityControls.makeHidden()
                                    eventsViewRouter.navigate(to: .eventDetailView(event: event))
                                }
                        }
                        .listStyle(.plain)
                    }
                    .transition(.move(edge: .leading))
                }
            }
            .environment(eventsViewRouter)
            .environment(tabVisibilityControls)
            .environment(calendarManager)
            .navigationTitle("Events")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $searchText)
            .sheet(isPresented: $calendarManager.showMonthYearPicker) {
                MonthYearPickerView(
                    isPresented: $calendarManager.showMonthYearPicker,
                    selectedDate: $calendarManager.currentMonth,
                    onDateSelected: { date in
                        calendarManager.selectDate(date)
                    }
                )
            }
            .navigationDestination(for: EventsViewRouter.Destination.self) { destination in
                switch destination {
                case .eventDetailView(let event):
                    EventDetailView(event: event)
                        .environment(eventsViewRouter)
                        .environment(HomeScreenRouter())
                case .eventCreationView(let event):
                    EventCreationView(event: event, isEdit: false)
                        .environment(eventsViewRouter)
                        .environment(HomeScreenRouter())
                case .eventUpdateView(let event):
                    EventCreationView(event: event, isEdit: true)
                        .environment(eventsViewRouter)
                        .environment(HomeScreenRouter())
                }
            }
            .onChange(of: eventsViewRouter.navPath) { oldPath, newPath in
                if newPath.isEmpty {
                    tabVisibilityControls.makeVisible()
                }
            }
            .toolbar {
                if UserManager.shared.isAdmin() {
                    ToolbarItem(placement: .topBarTrailing){
                        Button {
                            eventsViewRouter.navigate(to: .eventCreationView(event: Event.newEvent))
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
                Menu {
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

struct CustomEventsCardView: View {
    @State private var showConfirmationDialog = false
    @Environment(EventsViewRouter.self) var eventsViewRouter
    @Environment(TabsControl.self) var tabVisibilityControls

    let event: Event
    var body: some View {
        EventCardView(event: event, showRegistered: true)
            .listRowSeparator(.hidden, edges: .all)
            .swipeActions(edge: .trailing, allowsFullSwipe: false){
                if UserManager.shared.isAdmin() {
                    Button("", systemImage: "trash") { showConfirmationDialog = true}
                        .tint(.red)

                    Button("", systemImage: "pencil") {
                        eventsViewRouter.navigate(to: .eventUpdateView(event: event))
                        tabVisibilityControls.makeHidden()
                    }
                }
            }
            .contextMenu {
                if UserManager.shared.isAdmin() {
                    Button("Delete Event", systemImage: "trash", role: .destructive) {
                        showConfirmationDialog = true
                    }
                    Button("Edit Event", systemImage: "pencil") {
                        eventsViewRouter.navigate(to: .eventUpdateView(event: event))
                        tabVisibilityControls.makeHidden()
                    }
                }
            }
            .confirmationDialog(
                "Are you sure you want to delete this event?",
                isPresented: $showConfirmationDialog,
                titleVisibility: .visible
            ) {
                Button("Delete event", role: .destructive) {
                    if let targetEventId = event.id {
                        EventsManager.shared.deleteImageFromStorage(imageURL: event.imageURL)
                        EventsManager.shared.deleteEventFromDatabase(eventId: targetEventId)
                    }
                }
            }
    }
}

#Preview {
    EventsView()
        .environment(TabsControl())
        .environment(EventsViewRouter())
        .environment(UserManager.shared)
}


