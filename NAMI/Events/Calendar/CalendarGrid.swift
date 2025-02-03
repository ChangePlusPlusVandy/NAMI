//
//  CalendarGrid.swift
//  NAMI
//


import SwiftUI

struct CalendarGrid: View{
    let currentMonth: Date
    let events: [Event]
    let selectedDate: Date
    let onDateSelected: (Date) -> Void
    
    private let calendar = Calendar.current
    private let daysInWeek = 7
    private let dayNames = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"]
    
    //Events grouped by date
    private var eventsByDate: [Date: [Event]] {
        Dictionary(grouping: events) { event in
            calendar.startOfDay(for: event.startTime)
        }
    }
    
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                ForEach(dayNames, id: \.self) {day in
                        Text(day)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity)
                }
            }
            
            //Calendar grid
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: daysInWeek), spacing: 0) {
                ForEach(daysInMonth(), id: \.date) { dayInfo in
                    CalendarDayCell(
                        date: dayInfo.date,
                        events: eventsFor(date: dayInfo.date),
                        isCurrentMonth: dayInfo.isCurrentMonth,
                        isSelected: calendar.isDate(dayInfo.date, inSameDayAs: selectedDate)
                    )
                    .onTapGesture {
                        onDateSelected(dayInfo.date)
                    }
                }
            }
            
        }
    }
    
    private func daysInMonth() -> [DayInfo] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: currentMonth),
              let monthFirstWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.start),
              let monthLastWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.end)
        else {
            return []
        }
        
        let days = calendar.dateComponents([.day], from: monthInterval.start, to: monthInterval.end).day ?? 0
        
        var result: [DayInfo] = []
        
        // previous month days
        let preceedingDays = calendar.dateComponents([.day], from: monthFirstWeek.start, to: monthInterval.start).day ?? 0
        
        if preceedingDays > 0 {
            for day in 1...preceedingDays{
                if let date = calendar.date(byAdding: .day, value: -day, to: monthInterval.start) {
                    result.insert(DayInfo(date: date, isCurrentMonth: false), at: 0)
                }
            }
        }
        
        for day in 0..<days {
            if let date = calendar.date(byAdding: .day, value: day, to: monthInterval.start) {
                result.append(DayInfo(date: date, isCurrentMonth: true))
            }
        }
        
        let followingDays = calendar.dateComponents([.day], from: monthInterval.end, to: monthLastWeek.end).day ?? 0
        
        for day in 0..<followingDays {
            if let date = calendar.date(byAdding: .day,
                                         value: day,
                                         to: monthInterval.end) {
                result.append(DayInfo(date: date, isCurrentMonth: false))
            }
        }
        
        return result
    }
    
    private func eventsFor(date: Date) -> [Event] {
        let startOfDay = calendar.startOfDay(for: date)
        return eventsByDate[startOfDay] ?? []
    }
}

struct DayInfo {
    let date: Date
    let isCurrentMonth: Bool
}

#Preview {
    NavigationStack {
        CalendarGrid(
            currentMonth: Date(),
            events: [Event.dummyEvent],
            selectedDate: Date(),
            onDateSelected: { _ in }
        )
        .padding()
        .environment(TabsControl())
        .environment(HomeScreenRouter())
        .environment(EventsViewRouter())
    }
}
