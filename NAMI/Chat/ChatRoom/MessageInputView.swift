//
//  MessageInputView.swift
//  NAMI
//
//  Created by Zachary Tao on 2/21/25.
//

import SwiftUI

struct MessageInputView: View {
    @Binding var message: String
    @Environment(\.colorScheme) var colorScheme
    @FocusState.Binding var isFocused: Bool

    let onSend: () -> Void
    var body: some View {
        HStack {
            TextField("Type a message...", text: $message, axis: .vertical)
                .padding(.leading)
                .lineLimit(1...10)
                .frame(minHeight: 50)
                .background(colorScheme == .dark ? Color.clear : Color.white)
                .cornerRadius(15)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(colorScheme == .dark ? Color.secondary : Color.clear, lineWidth: 1)
                )
                .padding(.leading, 2)
                .focused($isFocused)
            Button(action: onSend) {
                Image(systemName: "arrow.up.circle.fill")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(Color.NAMIDarkBlue)
                    .disabled(message.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
        }
        .padding(.horizontal, 12)
        .padding(.bottom, 15)
    }
}
