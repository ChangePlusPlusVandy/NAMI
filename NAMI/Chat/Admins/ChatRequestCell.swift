//
//  ChatRequestCell.swift
//  NAMI
//
//  Created by Zachary Tao on 2/19/25.
//

import SwiftUI

struct ChatRequestCell: View {
    @Environment(ChatAdminRouter.self) var chatAdminRouter
    @Environment(TabsControl.self) var tabVisibilityControls

    var chatRequest: ChatRequest

    @State private var showDeleteConfirmation = false

    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    HStack {
                        Text(chatRequest.userName)
                            .font(.title3.bold())
                        Spacer()
                        Text(formatRelativeTime(from: chatRequest.requestTime))
                            .foregroundStyle(.secondary)
                    }
                    Text(chatRequest.requestReason)
                        .foregroundStyle(.secondary)
                }
            }
            Spacer(minLength: 10)
            HStack {
                Spacer()
                Button{
                    Task {
                        let newChatRoom = await ChatManager.shared.acceptChatRoomRequest(chatRequest: chatRequest, acceptAdminId: UserManager.shared.userID)
                        if let newChatRoom = newChatRoom {
                            tabVisibilityControls.makeHiddenNoAnimation()
                            chatAdminRouter.navigate(to: .chatRoomView(chatRoom: newChatRoom))
                        }
                    }
                } label: {
                    Text("Accept")
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color.NAMIDarkBlue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .buttonStyle(.borderless)

                Spacer(minLength: 20)
                Button{
                    showDeleteConfirmation = true
                } label: {
                    Text("Delete")
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .buttonStyle(.borderless)
                Spacer()
            }
        }
        .padding(.vertical, 10)
        .confirmationDialog(
            "Are you sure you want to delete this chat request from \(chatRequest.userName)?",
            isPresented: $showDeleteConfirmation,
            titleVisibility: .visible
        ) {
            Button("Delete", role: .destructive) {
                ChatManager.shared.deleteChatRoomRequest(chatRequestId: chatRequest.id ?? "")
            }
        }
    }
}

#Preview {
    List {
        ChatRequestCell(chatRequest: ChatRequest(requestId: "1213", userName: "John John", userId: "123", requestTime: Date(), requestReason: "This is my request reason This is my request reason This is my request reason This is my request reason This is my request reason"))
        ChatRequestCell(chatRequest: ChatRequest(requestId: "1213", userName: "John John", userId: "123", requestTime: Date(), requestReason: "This is my request reason"))
        ChatRequestCell(chatRequest: ChatRequest(requestId: "1213", userName: "John John", userId: "123", requestTime: Date(), requestReason: "This is my request reason"))
    }
    .environment(ChatAdminRouter())
    .environment(TabsControl())
}
