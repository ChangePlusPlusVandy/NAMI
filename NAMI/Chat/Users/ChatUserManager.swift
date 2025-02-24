//
//  ChatUserManager.swift
//  NAMI
//
//  Created by Zachary Tao on 2/18/25.
//

import FirebaseFirestore
import FirebaseStorage

@Observable
@MainActor
class ChatUserManager {
    let db = Firestore.firestore()
    var errorMessage = ""
    var currentChatRequestId: String?
    private var roomListener: ListenerRegistration?

    // user send chat request
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

    // Delete chat room and its messages
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

    func listenForChatRoomCreation(completion: @escaping (ChatRoom) -> Void) {
        // Clean up any existing listener
        roomListener?.remove()

        guard let currentChatRequestId else { return }

        // Listen directly for the new chat room with matching chatRequestId
        roomListener = db.collection("chatRooms")
            .whereField("chatRequestId", isEqualTo: currentChatRequestId)
            .addSnapshotListener { [weak self] roomSnapshot, error in
                guard let self else { return }

                if let error {
                    print("Error listening for chat room: \(error.localizedDescription)")
                    self.errorMessage = error.localizedDescription
                    return
                }

                guard let roomSnapshot else { return }

                // Look for newly added chat room
                for change in roomSnapshot.documentChanges {
                    if change.type == .added {
                        do {
                            let chatRoom = try change.document.data(as: ChatRoom.self)
                            completion(chatRoom)

                            // Clean up listener since we only need the first match
                            self.roomListener?.remove()
                        } catch {
                            print("Error decoding chat room: \(error.localizedDescription)")
                            self.errorMessage = error.localizedDescription
                        }
                    }
                }
            }
    }

    func cleanupListeners() {
        roomListener?.remove()
    }
}

