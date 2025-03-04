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
    @State private var showSignInView = false

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
                switch UserManager.shared.authenticationViewState {
                case .loading:
                    ProgressView()
                        .task {
                            await UserManager.shared.fetchUser()
                            UserManager.shared.startListeningForUserChanges()
                        }
                case .userOnBoarding:
                    UserOnboardingView()
                        .environment(authManager)
                case .home:
                    AppView()
                        .environment(authManager)
                        .task {
                            await UserManager.shared.fetchUser()
                            UserManager.shared.startListeningForUserChanges()
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
