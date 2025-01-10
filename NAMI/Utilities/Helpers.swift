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
