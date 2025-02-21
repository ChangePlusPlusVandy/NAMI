//
//  ChatRoomViewModel.swift
//  NAMI
//
//  Created by Zachary Tao on 2/21/25.
//

import SwiftUI
import FirebaseFirestore

@Observable
class ChatRoomViewModel {
    var messages: [ChatMessage] = []
    var newMessage: String = ""
    private var listenerRegistration: ListenerRegistration?
    private let db = Firestore.firestore()

    let chatRoom: ChatRoom
    let currentUserId: String

    init(chatRoom: ChatRoom, currentUserId: String) {
        self.chatRoom = chatRoom
        self.currentUserId = currentUserId
        startListeningToMessages()
    }

    func startListeningToMessages() {
        listenerRegistration?.remove()

        listenerRegistration = db.collection("messages")
            .whereField("chatRoomId", isEqualTo: chatRoom.id ?? "")
            .order(by: "timestamp", descending: false)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }

                if let error = error {
                    print("Error listening for messages: \(error)")
                    return
                }

                guard let documents = snapshot?.documents else { return }

                self.messages = documents.compactMap { document in
                    try? document.data(as: ChatMessage.self)
                }
            }
    }

    func sendMessage() {
        guard !newMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }

        let receiverId = currentUserId == chatRoom.userId ? chatRoom.adminId : chatRoom.userId

        let message = ChatMessage(
            chatRoomId: chatRoom.id ?? "",
            senderId: currentUserId,
            receiverId: receiverId,
            message: newMessage,
            timestamp: Date()
        )

        do {
            // Add new message
            let messageRef = try db.collection("messages").addDocument(from: message)

            // Update chat room's last message info
            if let roomId = chatRoom.id {
                db.collection("chatRooms").document(roomId).setData([
                    "lastMessageId": messageRef.documentID,
                    "lastMessageTimestamp": message.timestamp,
                    "lastMessage": message.message
                ], merge: true)
            }

            newMessage = ""
        } catch {
            print("Error sending message: \(error)")
        }
    }

    deinit {
        listenerRegistration?.remove()
    }
}
