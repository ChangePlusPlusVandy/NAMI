//
//  MessageBubble.swift
//  NAMI
//
//  Created by Zachary Tao on 2/21/25.
//

import SwiftUI

struct MessageBubble: View {
    let message: ChatMessage
    let isCurrentUser: Bool

    var body: some View {
        HStack {
            if isCurrentUser { Spacer() }

            VStack(alignment: isCurrentUser ? .trailing : .leading, spacing: 4) {
                Text(message.message)
                    .padding(12)
                    .background(isCurrentUser ? Color.NAMIDarkBlue : Color.gray.opacity(0.2))
                    .foregroundColor(isCurrentUser ? .white : .primary)
                    .cornerRadius(10)

                Text(formatRelativeTime(from: message.timestamp))
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }

            if !isCurrentUser { Spacer() }
        }
        .padding(.horizontal, 20)
    }
}
