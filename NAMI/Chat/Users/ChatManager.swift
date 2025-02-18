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
    static let shared = EventsManager()
    let db = Firestore.firestore()
    var errorMessage = ""

    func sendChatRoomRequest(requesterId: String) {

    }

    func acceptChatRoomRequest(chatAdminId: String) {

    }
}

