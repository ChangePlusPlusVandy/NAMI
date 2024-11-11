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

            case .unauthenticated, .authenticating:
                VStack {
                    SignUpView()
                        .environment(authManager)
                }

            case .authenticated:
                AppView()
                    .environment(authManager)
                    .onReceive(NotificationCenter.default.publisher(for: ASAuthorizationAppleIDProvider.credentialRevokedNotification)) { event in
                        authManager.signOut()
                        if let userInfo = event.userInfo, let info = userInfo["info"] {
                            print(info)
                        }
                    }

            }
        }
        .onChange(of: authManager.errorMessage) {
            showAlert = !authManager.errorMessage.isEmpty
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"), message: Text(authManager.errorMessage), dismissButton: .default(Text("OK")) {authManager.errorMessage = ""})
        }

    }
}
