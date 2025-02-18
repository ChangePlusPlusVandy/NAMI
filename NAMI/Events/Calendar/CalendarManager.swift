//
//  CalendarManager.swift
//  NAMI
//

import SwiftUI

@Observable
class CalendarManager {
    enum ViewOption {
        case calendar
        case list
    }
    
    private let calendar = Calendar.current
    var currentMonth: Date
    var selectedDate: Date
    var viewOption: ViewOption
    var showMonthYearPicker: Bool
    
    init() {
        self.currentMonth = Date()
        self.selectedDate = Date()
        self.viewOption = .list
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
            viewOption = viewOption == .calendar ? .list : .calendar
        }
    }
    
    func selectDate(_ date: Date) {
        selectedDate = date
        currentMonth = date
    }
}
