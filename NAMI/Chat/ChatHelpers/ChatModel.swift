//
//  ChatModel.swift
//  NAMI
//
//  Created by Zachary Tao on 2/18/25.
//

import Foundation
import FirebaseFirestore

struct ChatRequest: Identifiable, Equatable, Hashable, Codable {
    @DocumentID var id: String?
    var requestId: String

    var userName: String
    var userId: String
    var requestTime: Date
    var requestReason: String
}

struct ChatRoom: Identifiable, Equatable, Hashable, Codable {
    @DocumentID var id: String?
    var userId: String
    var adminId: String

    var userName: String
    var chatRequestId: String

    var lastMessageId: String?
    var lastMessageTimestamp: Date?
    var lastMessage: String?
}

struct ChatMessage: Identifiable, Equatable, Hashable, Codable {
    @DocumentID var id: String?
    var chatRoomId: String

    var senderId: String
    var receiverId: String

    var message: String
    var timestamp: Date
}
