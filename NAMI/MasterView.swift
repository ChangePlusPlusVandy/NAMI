//
//  AuthenticationView.swift
//  NAMI
//
//  Created by Zachary Tao on 11/10/24.
//

import SwiftUI
import AuthenticationServices

struct MasterView: View {
    @State private var authManager = AuthenticationManager()
    @State private var showAlert = false


    var body: some View {
        Group {
            switch authManager.authenticationState {

            case .welcomeStage:
                AppWelcomeView()
                    .environment(authManager)
                    .transition(AsymmetricTransition(insertion: .move(edge: .leading), removal: .identity))
                    .transition(.move(edge: .trailing))

            case .loginStage:
                LoginView()
                    .environment(authManager)
                    .transition(AsymmetricTransition(insertion: .move(edge: .trailing), removal: .identity))

            case .authenticated:
                AppView()
                    .environment(authManager)
                    .onReceive(NotificationCenter.default.publisher(for: ASAuthorizationAppleIDProvider.credentialRevokedNotification)) { event in
                        authManager.signOut()
                        if let userInfo = event.userInfo, let info = userInfo["info"] {
                            print(info)
                        }
                    }
                    .sheet(isPresented: $authManager.isFirstTimeSignIn) {
                        UserOnboardingView()
                            .environment(authManager)
                            .interactiveDismissDisabled()

                            //.transition(AsymmetricTransition(insertion: .move(edge: .trailing), removal: .identity))
                    }

            }
        }
        .animation(.default, value: authManager.authenticationState)
        .onChange(of: authManager.errorMessage) {
            showAlert = !authManager.errorMessage.isEmpty
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"), message: Text(authManager.errorMessage), dismissButton: .default(Text("OK")) {authManager.errorMessage = ""})
        }

    }
}
