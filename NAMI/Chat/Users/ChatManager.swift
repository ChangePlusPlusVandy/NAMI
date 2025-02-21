//
//  ChatManager.swift
//  NAMI
//
//  Created by Zachary Tao on 2/18/25.
//

import FirebaseFirestore
import FirebaseStorage

@Observable
@MainActor
class ChatManager {
    static let shared = ChatManager()
    let db = Firestore.firestore()
    var errorMessage = ""
    var currentChatRequestId: String?

    func sendChatRoomRequest(chatRequest: ChatRequest) {
        do {
            try db.collection("chatRequests").addDocument(from: chatRequest)
            currentChatRequestId = chatRequest.requestId
        } catch {
            print("error sending chat room request: \(error.localizedDescription)")
            errorMessage = error.localizedDescription
        }
    }

    func deleteChatRoomRequest(chatRequestId: String) {
        db.collection("chatRequests").document(chatRequestId).delete()
    }

    func deleteCurrentChatRoomRequest() {
        Task {
            do {
                if let currentChatRequestId {
                    let querySnapshot = try await db.collection("chatRequests").whereField("requestId", isEqualTo: currentChatRequestId).getDocuments()
                    for document in querySnapshot.documents {
                        try await document.reference.delete()
                    }
                }
            } catch {
                print("error sending chat room request: \(error.localizedDescription)")
                errorMessage = error.localizedDescription
            }
        }
    }

    func acceptChatRoomRequest(chatRequest: ChatRequest, acceptAdminId: String) async -> ChatRoom? {
        let batch = db.batch()
        // create chat room
        let chatRoomRef = db.collection("chatRooms").document()
        var chatRoom = ChatRoom(
            id: chatRoomRef.documentID,
            userId: chatRequest.userId,
            adminId: UserManager.shared.userID,
            userName: chatRequest.userName,
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
            errorMessage = error.localizedDescription
            return nil
        }
    }

    func deleteChat(chatRoom: ChatRoom) {
        Task {
            guard let roomId = chatRoom.id else { return }

            let batch = db.batch()

            // delete messages in the chat room
            let messagesSnapshot = try await db.collection("messages")
                .whereField("chatRoomId", isEqualTo: roomId)
                .getDocuments()

            for message in messagesSnapshot.documents {
                batch.deleteDocument(message.reference)
            }

            // 3. Delete the chat room itself
            let roomRef = db.collection("chatRooms").document(roomId)
            batch.deleteDocument(roomRef)

            // 4. Commit all deletions atomically
            try await batch.commit()
        }
    }
}

