//
//  CalendarDayDetailView.swift
//  NAMI
//

import SwiftUI

struct CalendarDayDetailView: View {
    @Environment(EventsViewRouter.self) var eventsViewRouter
    @Environment(TabsControl.self) var tabVisibilityControls
    
    let selectedDate: Date
    let events: [Event]
    
    private var filteredEvents: [Event] {
        events.filter { event in
            Calendar.current.isDate(event.startTime, inSameDayAs: selectedDate)
        }
    }
    
    var body: some View {
        if filteredEvents.isEmpty {
            emptyStateView
        } else {
            List(filteredEvents) { event in
                CustomEventsCardView(event: event)
                    .onTapGesture {
                        tabVisibilityControls.makeHidden()
                        eventsViewRouter.navigate(to: .eventDetailView(event: event))
                    }
            }
            .listStyle(.plain)
        }
    }
    
    private var emptyStateView: some View {
        VStack {
            Image(systemName: "calendar.badge")
                .font(.largeTitle)
                .foregroundStyle(.secondary)
            
            Text("No events found")
                .font(.headline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .frame(maxHeight: .infinity)
    }
}
