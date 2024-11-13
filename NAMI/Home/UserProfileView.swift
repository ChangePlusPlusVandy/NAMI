//
//  UserProfileView.swift
//  NAMI
//
//  Created by Zachary Tao on 11/10/24.
//

import SwiftUI

struct UserProfileView: View {
    @Environment(AuthenticationManager.self) var authManager
    @State private var showDeleteAccountAlert = false

    var body: some View {
        VStack {

            signOutButton
            deleteAccountButton
        }
        .navigationTitle("Profile")
    }

    var signOutButton: some View {
        Button("Sign Out") {
            authManager.signOut()
        }
        .buttonStyle(.bordered)
    }

    var deleteAccountButton: some View {
        Button("Delete Account", role: .destructive) {
            showDeleteAccountAlert.toggle()
        }
        .buttonStyle(.bordered)
        .tint(.red)
        .confirmationDialog("Are you sure you want to delete your account?", isPresented: $showDeleteAccountAlert, titleVisibility: .visible) {
            Button("Delete", role: .destructive, action: deleteAccount)
            Button("Cancel", role: .cancel) { showDeleteAccountAlert.toggle() }
        }
    }

    private func deleteAccount() {
        Task {
            if await authManager.signInWithGoogle() {
                let userID = UserManager.shared.userID
                if await authManager.deleteAccount() {
                    UserManager.shared.deleteUserInfo(userIDTarget: userID)
                }
            }
        }
    }
}

#Preview {
    UserProfileView()
        .environment(AuthenticationManager())
}
