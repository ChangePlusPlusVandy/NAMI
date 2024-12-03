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

        VStack (alignment: .leading) {

            VStack (alignment: .leading, spacing: 35) {
                profileRow(label: "First Name:", value: UserManager.shared.currentUser?.firstName)
                profileRow(label: "Last Name:", value: UserManager.shared.currentUser?.lastName)
                profileRow(label: "Email:", value: UserManager.shared.currentUser?.email)
                profileRow(label: "Phone:", value: UserManager.shared.currentUser?.phoneNumber)
                profileRow(label: "Zip Code:", value: UserManager.shared.currentUser?.zipCode)
            }
            .padding(.top, 50)
            .padding(.bottom, 20)

            Spacer()

            VStack (alignment: .center, spacing: 15) {
                donateButton
                signOutButton
                deleteAccountButton
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    homeScreenRouter.navigate(to: .userProfileEditView)
                } label: {
                    Text("Edit")
                }
            }
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
    }

    var donateButton: some View {
        Button {
            UIApplication.shared.open(URL(string: "https://secure.namidavidson.org/forms/namidavidsondonations")!)
        } label: {
            Text("Donate")
                .frame(width: 300, height: 50)
                .foregroundColor(.white)
                .background(Color.NAMITealBlue)
                .cornerRadius(10)
        }
    }

    var signOutButton: some View {
        Button {
            authManager.signOut()
        } label: {

            Text("Log out")
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
                .frame(width: 300, height: 50)
                .foregroundStyle(.white)
                .background(.red)
                .cornerRadius(10)
        }
        .confirmationDialog(
            "Are you sure you want to delete your account? This action is permanent and cannot be undone. To proceed, you will need to reauthenticate your account.",
            isPresented: $showDeleteAccountAlert, titleVisibility: .visible
        ) {
            Button("Delete", role: .destructive, action: deleteAccount)
            Button("Cancel", role: .cancel) { showDeleteAccountAlert.toggle() }
        }
    }

    private func deleteAccount() {
        Task {
            let userID = UserManager.shared.userID
            if await authManager.deleteAccount() {
                UserManager.shared.deleteUserInfo(userIDTarget: userID)
            }
        }
    }

    func profileRow(label: String, value: String?) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .fontWeight(.semibold)
            Text(value ?? "error")
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    NavigationStack {
        UserProfileView()
            .environment(AuthenticationManager())
            .environment(HomeScreenRouter())
    }
}
