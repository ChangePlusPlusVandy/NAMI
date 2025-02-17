//
//  CalendarSelection.swift
//  NAMI
//

import SwiftUI

// Shared components for calendar selection UI
struct CalendarSelection {
    struct DisplaySelectionButton: View {
        @Environment(CalendarManager.self) var calendarManager
        
        var body: some View {
            HStack(spacing: 0) {
                Button {
                    withAnimation {
                        calendarManager.toggleViewMode()
                    }
                } label: {
                    VStack(spacing: 5) {
                        Text("List")
                            .font(.callout)
                        Rectangle()
                            .frame(height: calendarManager.viewOption == .list ? 2 : 1)
                    }
                    .foregroundStyle(calendarManager.viewOption == .list ? Color.NAMIDarkBlue : Color.secondary)
                }
                .frame(maxWidth: .infinity)
                
                Button {
                    withAnimation {
                        calendarManager.toggleViewMode()
                    }
                } label: {
                    VStack(spacing: 5) {
                        Text("Calendar")
                            .font(.callout)
                        Rectangle()
                            .frame(height: calendarManager.viewOption == .calendar ? 2 : 1)
                    }
                    .foregroundStyle(calendarManager.viewOption == .calendar ? Color.NAMIDarkBlue : Color.secondary)
                }
                .frame(maxWidth: .infinity)
            }
        }
    }
    
    struct SelectionHeader: View {
        @Environment(CalendarManager.self) var calendarManager
        
        var body: some View {
            HStack {
                Button {
                    calendarManager.showMonthYearPicker = true
                } label: {
                    HStack {
                        Text(monthYearString(from: calendarManager.currentMonth))
                            .font(.title3.bold())
                        Image(systemName: "chevron.down")
                            .font(.caption.bold())
                    }
                }
                
                Spacer()
                
                Button {
                    calendarManager.previousMonth()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(Color.NAMIDarkBlue)
                }
                .padding(.horizontal, 10)

                Button {
                    calendarManager.nextMonth()
                } label: {
                    Image(systemName: "chevron.right")
                        .foregroundStyle(Color.NAMIDarkBlue)
                }
            }
        }
        
        private func monthYearString(from date: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM yyyy"
            return formatter.string(from: date)
        }
    }
}
