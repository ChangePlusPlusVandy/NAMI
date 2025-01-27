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
    
    private let calendar = Calendar.current
    
    private var filteredEvents: [Event] {
        events.filter { event in
            calendar.isDate(event.startTime, inSameDayAs: selectedDate)
        }
    }
    
    var body: some View {
        ScrollView {
            if filteredEvents.isEmpty {
                // No events view
                emptyStateView
                    .padding(.top, 40)
                    .transition(.opacity)
            } else {
                // Events list
                LazyVStack(spacing: 16) {
                    ForEach(filteredEvents) { event in
                        EventCardView(event: event, showRegistered: true)
                            .onTapGesture {
                                tabVisibilityControls.makeHidden()
                                eventsViewRouter.navigate(to: .eventDetailView(event: event))
                            }
                    }
                }
                .transition(.opacity)
            }
        }
        .padding(.horizontal)
        .animation(.smooth, value: filteredEvents.isEmpty)
    }
    
    // MARK: - Subviews
    
    private var emptyStateView: some View {
        VStack(spacing: 12) {
            Image(systemName: "calendar.badge.plus")
                .font(.largeTitle)
                .foregroundStyle(.secondary)
            
            Text("No events scheduled")
                .font(.headline)
                .foregroundStyle(.secondary)
            
            if UserManager.shared.isAdmin() {
                Button(action: {
                    var newEvent = Event.newEvent
                    newEvent.startTime = selectedDate
                    newEvent.endTime = calendar.date(byAdding: .hour, value: 1, to: selectedDate) ?? selectedDate
                    eventsViewRouter.navigate(to: .eventCreationView(event: newEvent))
                    tabVisibilityControls.makeHidden()
                }) {
                    Label("Create Event", systemImage: "plus.circle.fill")
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.NAMIDarkBlue)
                        .foregroundStyle(.white)
                        .clipShape(Capsule())
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

// MARK: - Preview
struct CalendarDayDetailView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Preview with events
            CalendarDayDetailView(
                selectedDate: Date(),
                events: [Event.dummyEvent, Event.dummyEvent]
            )
            .environment(EventsViewRouter())
            .environment(TabsControl())
            
            // Preview with no events
            CalendarDayDetailView(
                selectedDate: Date(),
                events: []
            )
            .environment(EventsViewRouter())
            .environment(TabsControl())
        }
    }
}
