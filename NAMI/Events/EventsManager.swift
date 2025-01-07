//
//  EventsManager.swift
//  NAMI
//
//  Created by Zachary Tao on 1/7/25.
//

import Foundation
import FirebaseFirestore

@Observable
@MainActor
class EventsManager {
    static let shared = EventsManager()
    let db = Firestore.firestore()
    var errorMessage = ""

    func addEventToDatabase(newEvent: Event) -> Bool {
        do {
            try db.collection("events").addDocument(from: newEvent)
            return true
        } catch {
            errorMessage = error.localizedDescription
            return false
        }
    }

    func deleteEventFromDatabase(eventId: String) {
        db.collection("events").document(eventId).delete()
    }

    func registerUserForEvent(eventId: String, userId: String) {
        db.collection("events").document(eventId).updateData(["registeredUsersIds": FieldValue.arrayUnion([userId])])
        db.collection("users").document(userId).updateData(["registeredEventsIds": FieldValue.arrayUnion([eventId])])
    }

    func cancelRegistrationForEvent(eventId: String, userId: String) {
        db.collection("events").document(eventId).updateData(["registeredUsersIds": FieldValue.arrayRemove([userId])])
        db.collection("users").document(userId).updateData(["registeredEventsIds": FieldValue.arrayRemove([eventId])])
    }

}

