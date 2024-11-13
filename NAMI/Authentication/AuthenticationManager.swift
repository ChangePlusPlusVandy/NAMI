//
//  AuthenticationManager.swift
//  NAMI
//
//  Created by Zachary Tao on 11/10/24.
//

import Foundation
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift
import Observation

enum AuthenticationState {
    case unauthenticated
    case authenticated
}

@MainActor
@Observable class AuthenticationManager {
    var authenticationState: AuthenticationState = .unauthenticated
    var errorMessage: String = ""
    var user: User?
    var isFirstTimeSignIn = false

    init() {
        registerAuthStateHandler()
    }

    private var authStateHandler: AuthStateDidChangeListenerHandle?

    private func registerAuthStateHandler() {
        if authStateHandler == nil {
            authStateHandler = Auth.auth().addStateDidChangeListener { auth, user in
                self.user = user
                self.authenticationState = user == nil ? .unauthenticated : .authenticated
            }
        }
    }

    func isUserFirstTimeLogIn() -> Bool {
        let newUserRref = Auth.auth().currentUser?.metadata
        /*Check if the automatic creation time of the user is equal to the last
         sign in time (Which will be the first sign in time if it is indeed
         their first sign in)*/
        if newUserRref?.creationDate?.timeIntervalSince1970 == newUserRref?.lastSignInDate?.timeIntervalSince1970{
            print("This is user first time login")
            print("Creation time: \(String(describing: newUserRref?.creationDate))")
            print("Last sign in time: \(String(describing: newUserRref?.lastSignInDate))")
            return true
        } else {
            return false
        }
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
        }
        catch {
            print(error)
            errorMessage = error.localizedDescription
        }
    }

    func deleteAccount() async -> Bool {
        do {
            try await user?.delete()
            return true
        }
        catch {
            errorMessage = error.localizedDescription
            print(errorMessage)
            return false
        }
    }
}

enum AuthenticationError: Error {
    case tokenError(message: String)
}

// Google Sign in
extension AuthenticationManager {
    func signInWithGoogle() async -> Bool {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            fatalError("No client ID found in Firebase configuration")
        }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first,
              let rootViewController = window.rootViewController else {
            print("There is no root view controller!")
            return false
        }

        do {
            let userAuthentication = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)

            let user = userAuthentication.user
            guard let idToken = user.idToken else { throw AuthenticationError.tokenError(message: "ID token missing") }
            let accessToken = user.accessToken

            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString,
                                                           accessToken: accessToken.tokenString)
            
            let result = try await Auth.auth().signIn(with: credential)
            if let isNewUser = result.additionalUserInfo?.isNewUser, isNewUser {
                isFirstTimeSignIn = true
            }
            let firebaseUser = result.user
            print("User \(firebaseUser.uid) signed in with email \(firebaseUser.email ?? "unknown")")
            return true
        }
        catch {
            print(error.localizedDescription)
            if error.localizedDescription != "The user canceled the sign-in flow."{
                self.errorMessage = error.localizedDescription
            }
            return false
        }
    }
}

