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
import AuthenticationServices
import Observation

enum AuthenticationState {
    case unauthenticated
    case authenticated
    case progress
}

@MainActor
@Observable class AuthenticationManager: NSObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let window = windowScene.windows.first else {
                fatalError("No window found")
            }
            return window
        }
    
    var authenticationState: AuthenticationState = .progress
    var errorMessage: String = ""
    var user: User?
    var isFirstTimeSignIn = false

    override init() {
        super.init()
        registerAuthStateHandler()
    }

    private var authStateHandler: AuthStateDidChangeListenerHandle?
    private var signInContinuation: CheckedContinuation<Bool, Never>?
    private var currentNonce: String?

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
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        var randomBytes = [UInt8](repeating: 0, count: length)
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        if errorCode != errSecSuccess {
            fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
        }
        let charset: [Character] = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        let nonce = randomBytes.map { byte in
            charset[Int(byte) % charset.count]
        }
        return String(nonce)
    }
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
            guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {
                self.signInContinuation?.resume(returning: false)
                return
            }
            
            guard let nonce = currentNonce else {
                self.signInContinuation?.resume(returning: false)
                return
            }
            
            guard let appleIDToken = appleIDCredential.identityToken,
                  let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                self.signInContinuation?.resume(returning: false)
                return
            }
            
            let credential = OAuthProvider.credential(
                withProviderID: "apple.com",
                idToken: idTokenString,
                rawNonce: nonce
            )
            
            Task {
                do {
                    let result = try await Auth.auth().signIn(with: credential)
                    if let isNewUser = result.additionalUserInfo?.isNewUser, isNewUser {
                        isFirstTimeSignIn = true
                        
                        // Update display name for new users if available
                        if let fullName = appleIDCredential.fullName {
                            let displayName = [fullName.givenName, fullName.familyName]
                                .compactMap { $0 }
                                .joined(separator: " ")
                            
                            if !displayName.isEmpty {
                                let changeRequest = result.user.createProfileChangeRequest()
                                changeRequest.displayName = displayName
                                try await changeRequest.commitChanges()
                            }
                        }
                    }
                    self.signInContinuation?.resume(returning: true)
                } catch {
                    print("Error signing in with Apple: \(error.localizedDescription)")
                    self.errorMessage = error.localizedDescription
                    self.signInContinuation?.resume(returning: false)
                }
            }
        }
        
        func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
            print("Sign in with Apple error: \(error.localizedDescription)")
            if (error as NSError).code != ASAuthorizationError.canceled.rawValue {
                self.errorMessage = error.localizedDescription
            }
            self.signInContinuation?.resume(returning: false)
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

    func reauthenticateSignInWithGoogle() async -> Bool{

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

            let _ = try await Auth.auth().currentUser?.reauthenticate(with: credential)

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

extension AuthenticationManager {
    func signInWithApple() async -> Bool {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let nonce = randomNonceString()
        currentNonce = nonce
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        
        return await withCheckedContinuation { continuation in
            self.signInContinuation = continuation
            authorizationController.performRequests()
        }
    }
    
    func reauthenticateSignInWithApple() async -> Bool {
        return await signInWithApple()
    }
}
