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
    var receiverId: String
    var message: String
    var timestamp: Date

}

struct ChatRoom: Identifiable, Equatable, Hashable, Codable {
    @DocumentID var id: String?
    var userId: String
    var adminId: String

    var lastMessageId: String?
    var lastMessageTimestamp: Date?
}

struct ChatRequest: Identifiable, Equatable, Hashable, Codable {
    @DocumentID var id: String?
    var requestId: String
    var userId: String
    var requestTime: Date
    var requestReason: String
}
