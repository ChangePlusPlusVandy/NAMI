//
//  UserManager.swift
//  NAMI
//
//  Created by Zachary Tao on 11/10/24.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

final class UserManager {
    static let shared = UserManager()
    var errorMessage = ""
    let db = Firestore.firestore()
    let userID = Auth.auth().currentUser?.uid ?? ""

    private var currentUser: NamiUser?


    private init () {
    }

    // Expose current user
    func getCurrentUser() -> NamiUser? {
        return currentUser
    }

    // Update the user info and refresh cache
    func updateUserInfo(updatedUser: NamiUser) async -> Bool {
        do {
            try db.collection("users").document(userID).setData(from: updatedUser, merge: true)
            currentUser = updatedUser
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
        } catch {
            errorMessage = error.localizedDescription
            print(errorMessage)
            currentUser = NamiUser.errorUser // Fallback if fetch fails
        }
    }

    // Create a new user and cache it
    func createNewUser(newUser: NamiUser) async {
        do {
            try db.collection("users").document(userID).setData(from: newUser)
            currentUser = newUser
        } catch {
            errorMessage = error.localizedDescription
            print(errorMessage)
        }
    }

    // Delete the user info
    func deleteUserInfo() {
        db.collection("users").document(userID).delete()
        currentUser = nil
    }
}
