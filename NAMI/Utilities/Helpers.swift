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
