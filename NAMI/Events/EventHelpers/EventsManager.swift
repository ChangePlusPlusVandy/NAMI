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
    
    func addEventToDatabase(newEvent: Event, isEdit: Bool) -> Bool {
        do {
            if isEdit,
               let newEventId = newEvent.id
            {
                try db.collection("events").document(newEventId).setData(from: newEvent)
            } else {
                try db.collection("events").addDocument(from: newEvent)
            }
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
    
    func uploadImageToStorage(image: UIImage?) async -> String {
        guard let imageData = image?.jpegData(compressionQuality: 1) else { return "" }
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
    
    func deleteImageFromStorage(imageURL: String) {
        Task {
            do {
                if !imageURL.isEmpty
                {
                    try await storage.reference(forURL: imageURL).delete()
                }
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }
}
