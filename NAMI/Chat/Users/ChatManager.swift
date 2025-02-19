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

    func acceptChatRoomRequest(chatAdminId: String) {

    }
}

