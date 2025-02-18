//
//  CalendarDayCell.swift
//  NAMI
//

import SwiftUI

struct CalendarDayCell: View {
    let date: Date
    let events: [Event]
    let isCurrentMonth: Bool
    let isSelected: Bool
    
    private let calendar = Calendar.current
    
    //Maximum no event indicators to show
    private let maxEventIndicators = 3
    
    private var dayNumber: Int {
        calendar.component(.day, from: date)
    }
    
    private var isToday: Bool {
        calendar.isDateInToday(date)
    }
    
    var body: some View {
        VStack(spacing: 4) {
            //Day number
            Text("\(dayNumber)")
                .font(.subheadline)
                .fontWeight(isToday ? .bold : .regular)
                .foregroundStyle(foregroundColor)
                .frame(width: 32, height: 32)
                .background(backgroundShape)
                .animation(.snappy(duration: 0.1), value: isSelected)
            
            //Event indicator
            if !events.isEmpty {
                HStack(spacing: 4) {
                    ForEach(Array(events.prefix(maxEventIndicators).enumerated()), id: \.element.id) { _, event in
                        Circle()
                            .fill(event.eventCategory.color)
                            .frame(width: 6, height: 6)
                    }
                    
                    if events.count > maxEventIndicators {
                        Text("+\(events.count - maxEventIndicators)")
                            .font(.system(size: 8))
                            .foregroundStyle(.secondary)
                    }
                }
                .frame(height: 6)
            } else {
                Spacer()
                    .frame(height: 6)
            }
        }
        .frame(height: 45)
        .contentShape(Rectangle())
    }
    
    private var foregroundColor: Color {
        if !isCurrentMonth {
            return .gray.opacity(0.5)
        }
        if isSelected {
            return .white
        }
        if isToday {
            return Color.NAMIDarkBlue
        }
        return .primary
    }
    
    @ViewBuilder
    private var backgroundShape: some View {
        if isSelected {
            Circle()
                .fill(Color.NAMIDarkBlue)
        } else if isToday {
            Circle()
                .stroke(Color.NAMIDarkBlue, lineWidth: 1)
        }
    }
}

struct CalendarDayCell_Previews: PreviewProvider {
    static var previews: some View {
        let today = Date()
        let calendar = Calendar.current
        
        Group {
            //Today with no events
            CalendarDayCell(
                date: today,
                events: [],
                isCurrentMonth: true,
                isSelected: false
            )
            
            // Selected day with events
            CalendarDayCell(
                date: calendar.date(byAdding: .day, value: 1, to: today)!,
                events: [Event.dummyEvent, Event.dummyEvent, Event.dummyEvent, Event.dummyEvent],
                isCurrentMonth: true,
                isSelected: true
            )
            
            // Non-current month day
            CalendarDayCell(
                date: calendar.date(byAdding: .month, value: 1, to: today)!,
                events: [Event.dummyEvent],
                isCurrentMonth: false,
                isSelected: false
            )
            
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
