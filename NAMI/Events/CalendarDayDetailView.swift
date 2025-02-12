//
//  CalendarDayDetailView.swift
//  NAMI
//

import SwiftUI

struct CalendarDayDetailView: View {
    @Environment(EventsViewRouter.self) var eventsViewRouter
    @Environment(TabsControl.self) var tabVisibilityControls
    // is it's home view the empty view should say "no event scheduled", if not it's "not event found"
    var isHomeView: Bool

    let selectedDate: Date
    let events: [Event]

    private let calendar = Calendar.current
    private var filteredEvents: [Event] {
        events.filter { event in
            calendar.isDate(event.startTime, inSameDayAs: selectedDate)
        }
    }

    var body: some View {
        if filteredEvents.isEmpty {
            emptyStateView
                .listRowSeparator(.hidden, edges: .all)
                .frame(maxHeight: .infinity)
        } else {
            List {
                ForEach(filteredEvents) { event in
                    CustomEventsCardView(event: event)
                        .environment(eventsViewRouter)
                        .environment(tabVisibilityControls)
                        .onTapGesture {
                            tabVisibilityControls.makeHidden()
                            eventsViewRouter.navigate(to: .eventDetailView(event: event))
                        }
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

            Text("No events \(isHomeView ? "scheduled" : "found")")
                .font(.headline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
}
