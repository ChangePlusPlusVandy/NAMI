//
//  Helpers.swift
//  NAMI
//
//  Created by Zachary Tao on 11/14/24.
//

import SwiftUI

struct CustomFilterLabelStyle: LabelStyle {
  func makeBody(configuration: Configuration) -> some View {
      HStack(spacing: 1){
          configuration.title
              .font(.caption)
          configuration.icon
              .imageScale(.small)

      }
  }
}

struct TextEditorWithPlaceholder: View {

    var minHeight: CGFloat = 300
    var bindText: Binding<String>
    var placeHolder: String

    var body: some View {
        TextEditor(text: bindText)
            .frame(minHeight: minHeight,
                   maxHeight: .infinity,
                   alignment: .center)
            .overlay(
                Text(bindText.wrappedValue == "" ? placeHolder : "")
                    .foregroundColor(.gray)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 8)
                    .allowsHitTesting(false)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            )
    }
}

func formatEventDurationWithTimeZone(startTime: Date, endTime: Date) -> String {
    return "\(startTime.formatted(date: .omitted, time: .shortened)) - \(endTime.formatted(date: .omitted, time: .shortened)) CST"
}

import MapKit

func openAddressInMap(address: String){
    let formattedAddress = address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    if let url = URL(string: "http://maps.apple.com/?q=\(formattedAddress)") {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}

func openAddressInGoogleMap(address: String){
    let formattedAddress = address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    if let url = URL(string: "comgooglemaps://?q=\(formattedAddress)") {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}

func withinOperatingHours() -> Bool {
    let now = Date()

    guard let cstTimeZone = TimeZone(identifier: "America/Chicago") else {
        return false
    }

    // Get the current hour in CST
    let calendar = Calendar.current
    let components = calendar.dateComponents(in: cstTimeZone, from: now)

    if let hour = components.hour {
        return hour >= 10 && hour < 22
    }

    return false
}

func formatRelativeTime(from date: Date) -> String {
    let now = Date()
    let calendar = Calendar.current
    let components = calendar.dateComponents([.minute, .hour, .day], from: date, to: now)

    // If less than 1 minute ago
    if components.minute ?? 0 < 1 {
        return "now"
    }

    // If less than 1 hour ago
    if components.hour ?? 0 < 1 {
        let minutes = components.minute ?? 0
        return "\(minutes) min ago"
    }

    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale.current

    // For same day, return time
    if calendar.isDateInToday(date) {
        dateFormatter.dateFormat = "h:mm a"
        return dateFormatter.string(from: date).lowercased()
    }

    // If yesterday, return "yesterday"
    if calendar.isDateInYesterday(date) {
        return "yesterday"
    }

    // For older dates, return full date
    dateFormatter.dateStyle = .medium
    dateFormatter.timeStyle = .none
    return dateFormatter.string(from: date)
}
