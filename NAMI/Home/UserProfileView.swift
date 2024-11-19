//
//  UserProfileView.swift
//  NAMI
//
//  Created by Zachary Tao on 11/10/24.
//

import SwiftUI

struct UserProfileView: View {
    @Environment(AuthenticationManager.self) var authManager
    @Environment(HomeScreenRouter.self) var homeScreenRouter
    @State private var showDeleteAccountAlert = false

    var body: some View {
        VStack {
            // TODO: Other information add here
            editProfileButton
            signOutButton
            deleteAccountButton
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Profile")
                    .franklinGothic(.regular, 28)
            }
        }
        
    }

    var editProfileButton: some View {
        Button {
            homeScreenRouter.navigate(to: .userProfileEditView)
        } label: {
            Text("Edit Profile")
                .proximaNova()
                .frame(width: 300, height: 50)
                .foregroundStyle(.white)
                .background(Color.NAMITealBlue)
                .cornerRadius(10)
        }
    }

    var signOutButton: some View {
        Button {
            authManager.signOut()
        } label: {
            Text("Sign Out")
                .proximaNova()
                .foregroundStyle(.black)
                .frame(width: 300, height: 50)
                .background(Color.white)
                .cornerRadius(10)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.primary, lineWidth: 1.5))
        }
    }

    var deleteAccountButton: some View {
        Button(role: .destructive) {
            showDeleteAccountAlert.toggle()
        } label: {
            Text("Delete Account")
                .proximaNova()
                .frame(width: 300, height: 50)
                .foregroundStyle(.white)
                .background(.red)
                .cornerRadius(10)
        }
        .confirmationDialog("Are you sure you want to delete your account? This action is permanent and cannot be undone. To proceed, you will need to reauthenticate your account.", isPresented: $showDeleteAccountAlert, titleVisibility: .visible) {
            Button("Delete", role: .destructive, action: deleteAccount)
            Button("Cancel", role: .cancel) { showDeleteAccountAlert.toggle() }
        }
    }

    private func deleteAccount() {
        Task {
            if await authManager.reauthenticateSignInWithGoogle() {
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
        .environment(HomeScreenRouter())
}
