//
//  AuthenticationView.swift
//  NAMI
//
//  Created by Zachary Tao on 11/10/24.
//

import SwiftUI

struct MasterView: View {
    @State private var authManager = AuthenticationManager()
    @State private var showAlert = false

    var body: some View {
        Group {
            switch authManager.authenticationState {

            case .progress:
                ProgressView()

            case .unauthenticated:
                LoginView()
                    .environment(authManager)
                    .task {
                        do {
                            try await Task.sleep(nanoseconds: 2_000_000_000)
                            UserManager.shared.clearCurrentUser()
                        } catch {
                            print("Error \(error.localizedDescription)")
                        }
                    }

            case .authenticated:
                if UserManager.shared.currentUser == nil {
                    ProgressView()
                        .task {
                            await UserManager.shared.fetchUser()
                            UserManager.shared.startListeningForUserChanges()
                        }
                } else {
                    AppView()
                        .environment(authManager)
                        .fullScreenCover(isPresented: $authManager.isFirstTimeSignIn) {
                            UserOnboardingView()
                                .environment(authManager)
                                .interactiveDismissDisabled()
                        }
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
