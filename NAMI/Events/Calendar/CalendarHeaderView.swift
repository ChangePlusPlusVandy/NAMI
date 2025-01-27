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
    @Binding var showMonthYearPicker: Bool
    
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
                Button(action: { showMonthYearPicker = true }) {
                    HStack {
                        Text(monthYearString)
                            .font(.title3.bold())
                        Image(systemName: "chevron.down")
                            .font(.caption.bold())
                    }
                    .foregroundStyle(Color.primary)
                }
                
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

struct MonthYearPickerView: View {
    @Binding var isPresented: Bool
    @Binding var selectedDate: Date
    let onDateSelected: (Date) -> Void
    
    private let calendar = Calendar.current
    @State private var selectedMonth: Int
    @State private var selectedYear: Int
    
    private let months = [
        "January", "February", "March", "April", "May", "June",
        "July", "August", "September", "October", "November", "December"
    ]
    
    private let years: [Int] = {
        let currentYear = Calendar.current.component(.year, from: Date())
        return Array(currentYear - 2...currentYear + 5)
    }()
    
    init(isPresented: Binding<Bool>, selectedDate: Binding<Date>, onDateSelected: @escaping (Date) -> Void) {
        self._isPresented = isPresented
        self._selectedDate = selectedDate
        self.onDateSelected = onDateSelected
        
        let calendar = Calendar.current
        let month = calendar.component(.month, from: selectedDate.wrappedValue)
        let year = calendar.component(.year, from: selectedDate.wrappedValue)
        
        self._selectedMonth = State(initialValue: month - 1)
        self._selectedYear = State(initialValue: year)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                // Month picker
                Picker("", selection: $selectedMonth) {
                    ForEach(0..<months.count, id: \.self) { index in
                        Text(months[index])
                            .font(.system(size: 20))
                            .tag(index)
                    }
                }
                .pickerStyle(.wheel)
                .frame(width: 150)
                
                // Year picker
                Picker("", selection: $selectedYear) {
                    ForEach(years, id: \.self) { year in
                        Text(String(year))
                            .font(.system(size: 20))
                            .tag(year)
                    }
                }
                .pickerStyle(.wheel)
                .frame(width: 100)
            }
            .padding(.top)
            
            // Select button with highlight background
            Button(action: selectDate) {
                HStack {
                    Spacer()
                    Text("Select")
                        .foregroundStyle(.white)
                    Spacer()
                }
                .padding(.vertical, 12)
                .background(Color.NAMIDarkBlue)
                .cornerRadius(8)
                .padding(.horizontal)
            }
            .padding(.top, 20)
            .padding(.bottom, 8)
        }
        .presentationDetents([.height(250)])
        .presentationBackground(.background)
    }
    
    private func selectDate() {
        var dateComponents = DateComponents()
        dateComponents.year = selectedYear
        dateComponents.month = selectedMonth + 1
        dateComponents.day = 1
        
        if let date = calendar.date(from: dateComponents) {
            selectedDate = date
            onDateSelected(date)
            isPresented = false
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
                isCalendarView: true,
                showMonthYearPicker: .constant(false)
            )
            
            // List view mode
            CalendarHeaderView(
                currentMonth: Date(),
                onPreviousMonth: {},
                onNextMonth: {},
                onToggleViewMode: {},
                isCalendarView: false,
                showMonthYearPicker: .constant(false)
            )
            
            // Jump to date sheet
            MonthYearPickerView(
                isPresented: .constant(true),
                selectedDate: .constant(Date()),
                onDateSelected: { _ in }
            )
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
