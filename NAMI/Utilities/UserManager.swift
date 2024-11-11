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

    private init () {}

    func fetchUserInfo() async -> NamiUser {
        do {
            return try await db.collection("users").document(userID).getDocument().data(as: NamiUser.self)
        } catch {
            errorMessage = error.localizedDescription
            print(errorMessage)
            return NamiUser.errorUser
        }
    }

    func createNewUser(newUser: NamiUser) {
        do {
            try db.collection("users").document(userID).setData(from: newUser)
        } catch {
            errorMessage = error.localizedDescription
            print(errorMessage)
        }
    }

    func deleteUserInfo() {
        db.collection("users").document(userID).delete()
    }
}
