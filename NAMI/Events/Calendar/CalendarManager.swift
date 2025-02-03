//
//  CalendarManager.swift
//  NAMI
//

import SwiftUI

@Observable
class CalendarManager {
    private let calendar = Calendar.current
    
    var currentMonth: Date
    var selectedDate: Date
    var isCalendarView: Bool
    var showMonthYearPicker: Bool
    
    init() {
        self.currentMonth = Date()
        self.selectedDate = Date()
        self.isCalendarView = false
        self.showMonthYearPicker = false
    }
    
    func previousMonth() {
        withAnimation {
            currentMonth = calendar.date(
                byAdding: .month,
                value: -1,
                to: currentMonth
            ) ?? currentMonth
        }
    }
    
    func nextMonth() {
        withAnimation {
            currentMonth = calendar.date(
                byAdding: .month,
                value: 1,
                to: currentMonth
            ) ?? currentMonth
        }
    }
    
    func toggleViewMode() {
        withAnimation {
            isCalendarView.toggle()
        }
    }
    
    func selectDate(_ date: Date) {
        withAnimation {
            selectedDate = date
            currentMonth = date
        }
    }
}
