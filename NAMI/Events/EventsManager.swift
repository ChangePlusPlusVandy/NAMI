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
    
    let dummyEvent = Event(title: "",
         startTime: Calendar.current.date(bySettingHour: 15, minute: 0, second: 0, of: Date())!,
         endTime: Date(timeInterval: 3600, since: Calendar.current.date(bySettingHour: 15, minute: 0, second: 0, of: Date())!),
         repeatType: .never,
         endRepeat: false,
         endRepeatDate: Date(),
         about: "",
         leaderName: "",
         leaderPhoneNumber: "",
         meetingMode: .inPerson(location: ""),
         eventCategory: .familySupport,
         eventSeries: "",
         registeredUsersIds: [],
         imageURL: "")

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
    
    func updateEventFromDatabase(event: Event) -> Bool {
        if event.id != nil {
            deleteEventFromDatabase(eventId: event.id!)
            return addEventToDatabase(newEvent: event)
//            db.collection("events").document(event.id!).updateData(["title": event.title, "about": event.about, "endRepeat": event.endRepeat, "endRepeatDate": event.endRepeatDate, "endTime": event.endTime, "eventCategory": event.eventCategory.rawValue, "eventSeries": event.eventSeries, "imageURL": event.imageURL, "leaderName": event.leaderName, "leaderPhoneNumber": event.leaderPhoneNumber, "meetingMode": event.meetingMode.displayName, "repeatType": event.repeatType.rawValue, "registeredUsersIds": event.registeredUsersIds, "startTime": event.startTime])
        } else {
            print("Error updating event")
            return false
        }
    }
}
