//
//  EventsManager.swift
//  NAMI
//
//  Created by Zachary Tao on 1/7/25.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

@Observable
@MainActor
class EventsManager {
    static let shared = EventsManager()
    let db = Firestore.firestore()
    let storage = Storage.storage()
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
    
    func deleteImageFromDataBase(imageUrl: String) async {
        if imageUrl != "" {
            do {
                try await storage.reference(for: URL(string: imageUrl)!).delete()
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }

    func registerUserForEvent(eventId: String, userId: String) {
        db.collection("events").document(eventId).updateData(["registeredUsersIds": FieldValue.arrayUnion([userId])])
        db.collection("users").document(userId).updateData(["registeredEventsIds": FieldValue.arrayUnion([eventId])])
    }

    func cancelRegistrationForEvent(eventId: String, userId: String) {
        db.collection("events").document(eventId).updateData(["registeredUsersIds": FieldValue.arrayRemove([userId])])
        db.collection("users").document(userId).updateData(["registeredEventsIds": FieldValue.arrayRemove([eventId])])
    }

    func uploadImageToStorage(image: UIImage?) async -> String {
        guard let imageData = image?.jpegData(compressionQuality: 0.3) else { return "" }
        let ref = storage.reference().child("eventImages/\(UUID().uuidString).jpg")

        do {
            let _ = try await ref.putDataAsync(imageData)
            let imageURL = try await ref.downloadURL()
            print("image uploaded: \(imageURL.absoluteString)")
            return imageURL.absoluteString
        } catch {
            errorMessage = error.localizedDescription
            return ""
        }
    }
}

