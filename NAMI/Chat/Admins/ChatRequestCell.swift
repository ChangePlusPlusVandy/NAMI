//
//  ChatRequestCell.swift
//  NAMI
//
//  Created by Zachary Tao on 2/19/25.
//

import SwiftUI
import FirebaseFirestore

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
                        let newChatRoom = await acceptChatRoomRequest(chatRequest: chatRequest, acceptAdminId: UserManager.shared.userID)
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
                deleteChatRoomRequest(chatRequestId: chatRequest.id ?? "")
            }
        }
    }

    func acceptChatRoomRequest(chatRequest: ChatRequest, acceptAdminId: String) async -> ChatRoom? {
        let db = Firestore.firestore()
        let batch = db.batch()
        // create chat room
        let chatRoomRef = db.collection("chatRooms").document()
        var chatRoom = ChatRoom(
            id: chatRoomRef.documentID,
            userId: chatRequest.userId,
            adminId: UserManager.shared.userID,
            userName: chatRequest.userName,
            chatRequestId: chatRequest.requestId,
            lastMessageId: nil,
            lastMessageTimestamp: nil
        )

        // create the first message
        let messageRef = db.collection("messages").document()
        let welcomeMessage = ChatMessage(
            chatRoomId: chatRoomRef.documentID,
            senderId: chatRequest.userId,
            receiverId: acceptAdminId,
            message: chatRequest.requestReason,
            timestamp: chatRequest.requestTime
        )

        // update chat room with first message
        chatRoom.lastMessageId = messageRef.documentID
        chatRoom.lastMessageTimestamp = welcomeMessage.timestamp
        chatRoom.lastMessage = chatRequest.requestReason

        // update chat room to server
        do {
            try batch.setData(from: chatRoom, forDocument: chatRoomRef)
            try batch.setData(from: welcomeMessage, forDocument: messageRef)

            // delete the original request
            if let requestId = chatRequest.id {
                let requestRef = db.collection("chatRequests").document(requestId)
                batch.deleteDocument(requestRef)
            }

            try await batch.commit()

            return chatRoom
        } catch {
            print("error accepting chat room request: \(error.localizedDescription)")
            return nil
        }
    }

    func deleteChatRoomRequest(chatRequestId: String) {
        Firestore.firestore().collection("chatRequests").document(chatRequestId).delete()
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
