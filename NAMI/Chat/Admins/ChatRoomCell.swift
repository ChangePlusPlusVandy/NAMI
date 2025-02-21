//
//  ChatRoomCell.swift
//  NAMI
//
//  Created by Zachary Tao on 2/21/25.
//

import SwiftUI

struct ChatRoomCell: View {
    @Environment(ChatAdminRouter.self) var chatAdminRouter
    @Environment(TabsControl.self) var tabVisibilityControls

    var chatRoom: ChatRoom

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(chatRoom.userName)
                    .font(.title3)
                    .fontWeight(.bold)
                Spacer()
                if let lastMessageTimestamp = chatRoom.lastMessageTimestamp {
                    Text(formatRelativeTime(from: lastMessageTimestamp))
                        .foregroundStyle(.secondary)
                }

                Button {
                    chatAdminRouter.navigate(to: .chatRoomView(chatRoom: chatRoom))
                    tabVisibilityControls.makeHiddenNoAnimation()
                } label: {
                    Image(systemName: "chevron.right")
                        .foregroundStyle(.secondary)
                        .imageScale(.small)
                        .bold()
                }
            }
            if let lastMessage = chatRoom.lastMessage {
                Text(lastMessage)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
        }
        .padding(.vertical, 10)
    }
}

#Preview {
    List {
        ChatRoomCell(chatRoom: ChatRoom(userId: "", adminId: "", userName: "Zach Tao", lastMessageTimestamp: Date(), lastMessage: "Hello this is a message Hello this is a message Hello this is a message Hello this is a message"))
        ChatRoomCell(chatRoom: ChatRoom(userId: "", adminId: "", userName: "Zach Tao", lastMessageTimestamp: Date(), lastMessage: "Hello this is a message"))
        ChatRoomCell(chatRoom: ChatRoom(userId: "", adminId: "", userName: "Zach Tao", lastMessageTimestamp: Date(), lastMessage: "Hello this is a message"))
    }
    .environment(ChatAdminRouter())
    .environment(TabsControl())
}
