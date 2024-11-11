//
//  AuthenticationView.swift
//  NAMI
//
//  Created by Zachary Tao on 11/10/24.
//

import SwiftUI
import AuthenticationServices

struct MasterView: View {
    @StateObject private var authManager = AuthenticationManager()

    var body: some View {
        Group {
            switch authManager.authenticationState {

            case .unauthenticated, .authenticating:
                VStack {
                    SignUpView()
                        .environmentObject(authManager)
                }

            case .authenticated:
                AppView()
                    .environmentObject(authManager)
                    .onReceive(NotificationCenter.default.publisher(for: ASAuthorizationAppleIDProvider.credentialRevokedNotification)) { event in
                        authManager.signOut()
                        if let userInfo = event.userInfo, let info = userInfo["info"] {
                            print(info)
                        }
                    }

            }
        }
    }
}
