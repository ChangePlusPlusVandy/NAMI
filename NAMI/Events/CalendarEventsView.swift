//
//  CalendarEventsView.swift
//  NAMI
//

import SwiftUI
import FirebaseFirestore

struct CalendarEventsView: View {
    @Environment(TabsControl.self) var tabVisibilityControls
    @Environment(EventsViewRouter.self) var eventsViewRouter
    
    // State for calendar
    @State private var currentMonth: Date = Date()
    @State private var selectedDate: Date = Date()
    @State private var isCalendarView: Bool = true
    @State private var showMonthYearPicker: Bool = false
    
    // Filter state
    @State private var searchText: String = ""
    @State private var selectedMeetingMode: MeetingMode?
    @State private var selectedCategory: EventCategory?
    
    // Events query
    @FirestoreQuery(
        collectionPath: "events",
        predicates: [.order(by: "startTime", descending: false)],
        animation: .default
    ) var events: [Event]
    
    private var filteredEvents: [Event] {
        events.filter { event in
            (selectedCategory == nil || event.eventCategory == selectedCategory) &&
            (searchText.isEmpty ||
             event.title.localizedCaseInsensitiveContains(searchText) ||
             event.about.localizedCaseInsensitiveContains(searchText)) &&
            (selectedMeetingMode == nil ||
             event.meetingMode.displayName == selectedMeetingMode?.displayName)
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header with view toggle and month navigation
            CalendarHeaderView(
                currentMonth: currentMonth,
                onPreviousMonth: previousMonth,
                onNextMonth: nextMonth,
                onToggleViewMode: toggleViewMode,
                isCalendarView: isCalendarView,
                showMonthYearPicker: $showMonthYearPicker
            )
            
            // Filter menu (reused from EventsView)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    // Category filter
                    Menu {
                        let selected = Binding(
                            get: { selectedCategory },
                            set: { selectedCategory = $0 == selectedCategory ? nil : $0 }
                        )
                        
                        Picker("Category", selection: selected) {
                            ForEach(EventCategory.allCases) { category in
                                Text(category.rawValue).tag(category as EventCategory?)
                            }
                        }
                    } label: {
                        Label(selectedCategory?.rawValue ?? "All Categories",
                              systemImage: "chevron.down")
                    }
                    
                    // Meeting mode filter
                    Menu {
                        let selected = Binding(
                            get: { selectedMeetingMode },
                            set: { selectedMeetingMode = $0 == selectedMeetingMode ? nil : $0 }
                        )
                        Picker("Mode", selection: selected) {
                            Label("Virtual", systemImage: "laptopcomputer.and.iphone")
                                .tag(MeetingMode.virtual(link: "") as MeetingMode?)
                            Label("In Person", systemImage: "person.3")
                                .tag(MeetingMode.inPerson(location: "") as MeetingMode?)
                        }
                    } label: {
                        Label(selectedMeetingMode?.displayName ?? "All Modes",
                              systemImage: "chevron.down")
                    }
                }
                .labelStyle(CustomFilterLabelStyle())
                .buttonStyle(.bordered)
                .buttonBorderShape(.capsule)
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            
            if isCalendarView {
                // Calendar view
                VStack {
                    CalendarGrid(
                        currentMonth: currentMonth,
                        events: filteredEvents,
                        selectedDate: selectedDate,
                        onDateSelected: { date in
                            withAnimation {
                                selectedDate = date
                            }
                        }
                    )
                    
                    Divider()
                        .padding(.vertical, 8)
                    
                    // Selected day's events
                    CalendarDayDetailView(
                        selectedDate: selectedDate,
                        events: filteredEvents
                    )
                }
                .transition(.move(edge: .trailing))
            } else {
                // reusing EventsView logic
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(filteredEvents) { event in
                            EventCardView(event: event, showRegistered: true)
                                .onTapGesture {
                                    tabVisibilityControls.makeHidden()
                                    eventsViewRouter.navigate(to: .eventDetailView(event: event))
                                }
                        }
                    }
                    .padding()
                }
                .transition(.move(edge: .leading))
            }
        }
        .searchable(text: $searchText)
        .sheet(isPresented: $showMonthYearPicker) {
            MonthYearPickerView(
                isPresented: $showMonthYearPicker,
                selectedDate: $currentMonth,
                onDateSelected: { date in
                    withAnimation {
                        currentMonth = date
                        selectedDate = date
                    }
                }
            )
        }
        .toolbar {
            if UserManager.shared.isAdmin() {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        eventsViewRouter.navigate(to: .eventCreationView(event: Event.newEvent))
                        tabVisibilityControls.makeHidden()
                    } label: {
                        Image(systemName: "plus.app")
                    }
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showMonthYearPicker = true
                } label: {
                    Image(systemName: "calendar")
                }
            }
        }
    }
    
    // Helper Methods
    
    private func toggleViewMode() {
        withAnimation {
            isCalendarView.toggle()
        }
    }
    
    private func previousMonth() {
        withAnimation {
            currentMonth = Calendar.current.date(
                byAdding: .month,
                value: -1,
                to: currentMonth
            ) ?? currentMonth
        }
    }
    
    private func nextMonth() {
        withAnimation {
            currentMonth = Calendar.current.date(
                byAdding: .month,
                value: 1,
                to: currentMonth
            ) ?? currentMonth
        }
    }
}

//  Preview
struct CalendarEventsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            CalendarEventsView()
                .environment(TabsControl())
                .environment(EventsViewRouter())
        }
    }
}
