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
        } catch {
            errorMessage = error.localizedDescription
            print(errorMessage)
        }
    }

    // Delete the user info
    func deleteUserInfo(userIDTarget: String) {
        db.collection("users").document(userIDTarget).delete()
        currentUser = nil
    }
}
