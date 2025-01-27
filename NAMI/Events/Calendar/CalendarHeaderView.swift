//
//  CalendarHeaderView.swift
//  NAMI
//

import SwiftUI

struct CalendarHeaderView: View {
    let currentMonth: Date
    let onPreviousMonth: () -> Void
    let onNextMonth: () -> Void
    let onToggleViewMode: () -> Void
    let isCalendarView: Bool
    
    private let calendar = Calendar.current
    
    private var monthYearString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: currentMonth)
    }
    
    var body: some View {
        VStack(spacing: 16) {
            // List/Calendar toggle
            HStack {
                Button(action: onToggleViewMode) {
                    Text("List")
                        .foregroundStyle(!isCalendarView ? Color.NAMIDarkBlue : .gray)
                }
                
                Button(action: onToggleViewMode) {
                    Text("Calendar")
                        .foregroundStyle(isCalendarView ? Color.NAMIDarkBlue : .gray)
                }
            }
            
            // Month navigation
            HStack {
                Text(monthYearString)
                    .font(.title3.bold())
                
                Spacer()
                
                HStack(spacing: 20) {
                    Button(action: onPreviousMonth) {
                        Image(systemName: "chevron.left")
                            .foregroundStyle(Color.NAMIDarkBlue)
                    }
                    
                    Button(action: onNextMonth) {
                        Image(systemName: "chevron.right")
                            .foregroundStyle(Color.NAMIDarkBlue)
                    }
                }
            }
        }
        .padding(.horizontal)
    }
}

// Jump To Date Sheet
struct JumpToDateView: View {
    @Binding var isPresented: Bool
    @Binding var selectedDate: Date
    let onDateSelected: (Date) -> Void
    
    var body: some View {
        NavigationView {
            DatePicker(
                "Select Date",
                selection: $selectedDate,
                displayedComponents: [.date]
            )
            .datePickerStyle(.graphical)
            .tint(Color.NAMIDarkBlue)
            .navigationTitle("Jump to Date")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        onDateSelected(selectedDate)
                        isPresented = false
                    }
                }
            }
        }
    }
}

//  Preview
struct CalendarHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Calendar view mode
            CalendarHeaderView(
                currentMonth: Date(),
                onPreviousMonth: {},
                onNextMonth: {},
                onToggleViewMode: {},
                isCalendarView: true
            )
            
            // List view mode
            CalendarHeaderView(
                currentMonth: Date(),
                onPreviousMonth: {},
                onNextMonth: {},
                onToggleViewMode: {},
                isCalendarView: false
            )
            
            // Jump to date sheet
            JumpToDateView(
                isPresented: .constant(true),
                selectedDate: .constant(Date()),
                onDateSelected: { _ in }
            )
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
