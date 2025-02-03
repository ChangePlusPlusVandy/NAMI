//
//  MonthYearPickerView.swift
//  NAMI
//

import SwiftUI

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
            
            // Select button
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

#Preview {
    Text("Tap to show picker")
        .sheet(isPresented: .constant(true)) {
            MonthYearPickerView(
                isPresented: .constant(true),
                selectedDate: .constant(Date()),
                onDateSelected: { _ in }
            )
        }
}
