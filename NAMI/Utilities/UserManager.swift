//
//  UserManager.swift
//  NAMI
//
//  Created by Zachary Tao on 11/10/24.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

@Observable
@MainActor
final class UserManager {
    static let shared = UserManager()
    var errorMessage = ""
    let db = Firestore.firestore()
    var userID: String { Auth.auth().currentUser?.uid ?? "" }

    var currentUser: NamiUser?
    var userType: UserType = .member
    private var listenerRegistration: ListenerRegistration?
    
    private init () {}

    // Expose current user
    func getCurrentUser() -> NamiUser? {
        print("Current user: \(currentUser.debugDescription)")
        return currentUser
    }

    func clearCurrentUser() {
        currentUser = nil
    }

    // Update the user info and refresh cache
    func updateUserInfo(updatedUser: NamiUser) async -> Bool {
        do {
            try db.collection("users").document(userID).setData(from: updatedUser, merge: true)
            currentUser = updatedUser
            userType = updatedUser.userType
            print("User information is updated \(String(describing: currentUser))")
            return true
        } catch {
            errorMessage = error.localizedDescription
            print(errorMessage)
            return false
        }
    }

    // Fetch and cache the user info
    // called when account is logged in
    func fetchUser() async {
        do {
            currentUser = try await db.collection("users").document(userID).getDocument().data(as: NamiUser.self)
            userType = currentUser?.userType ?? .member
            print("User information is fetched \(String(describing: currentUser))")
        } catch {
            errorMessage = error.localizedDescription
            print(errorMessage)
        }
    }

    // Create a new user and cache it
    func createNewUser(newUser: NamiUser) async {
        do {
            print("User id: \(userID) is created in the database")
            try db.collection("users").document(userID).setData(from: newUser)
            currentUser = newUser
            userType = newUser.userType
            print("User information is created \(String(describing: currentUser))")
        } catch {
            errorMessage = error.localizedDescription
            print(errorMessage)
        }
    }

    // Delete the user info
    func deleteUserInfo(userIDTarget: String) {
        db.collection("users").document(userIDTarget).delete()
        currentUser = nil
        print("User information is deleted \(String(describing: currentUser))")
    }

    func startListeningForUserChanges() {
        // Remove any existing listener first (just to be safe)
        stopListeningForUserChanges()

        guard !userID.isEmpty else { return }

        listenerRegistration = db.collection("users")
            .document(userID)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }

                if let error = error {
                    self.errorMessage = "Error in snapshot listener: \(error.localizedDescription)"
                    print(self.errorMessage)
                    return
                }

                // If the document doesn't exist, set currentUser to nil
                guard let snapshot = snapshot, snapshot.exists else {
                    self.currentUser = nil
                    self.userType = .member
                    return
                }

                do {
                    // Convert the snapshot data to NamiUser
                    let user = try snapshot.data(as: NamiUser.self)
                    self.currentUser = user
                    self.userType = user.userType
                    print("User information is listened \(String(describing: currentUser))")
                } catch {
                    self.errorMessage = "Error decoding user: \(error.localizedDescription)"
                    print(self.errorMessage)
                }
            }
    }

    func stopListeningForUserChanges() {
        listenerRegistration?.remove()
        listenerRegistration = nil
    }
}
