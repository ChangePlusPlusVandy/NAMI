//
//  ChatModel.swift
//  NAMI
//
//  Created by Zachary Tao on 2/18/25.
//

import Foundation
import FirebaseFirestore

struct ChatMessage: Identifiable, Equatable, Hashable, Codable {
    @DocumentID var id: String?
    var chatRoomId: String
    var senderId: String
    var message: String
}

struct ChatRoom: Identifiable, Equatable, Hashable, Codable {
    @DocumentID var id: String?
    var userId: String
}
