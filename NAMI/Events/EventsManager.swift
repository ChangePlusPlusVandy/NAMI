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
    
    func imageToURL(data: Data?, newEvent: Event) -> String {
        //from https://firebase.google.com/docs/storage/ios/upload-files
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let ref = storageRef.child("images/\(UUID().uuidString).jpg")
        var ret = ""
        _ = ref.putData(data!, metadata: nil) { (metadata, error) in
            guard metadata != nil else {
                print("Error uploading image")
                return
            }
            ref.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    print("Error downloading image")
                    return
                }
                print("\(downloadURL)")
                ret = "\(downloadURL)"
            }
        }
        return ret
    }

}

