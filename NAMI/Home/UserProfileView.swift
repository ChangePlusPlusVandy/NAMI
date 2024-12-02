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
        header
        VStack {
            Group {
                profileRow(label: "Username:", value: "UserName_insert")
                profileRow(label: "First Name:", value: "name_insert")
                profileRow(label: "Last Name:", value: "last_Name_insert")
                profileRow(label: "Email:", value: "person@email.com")
                profileRow(label: "Phone:", value: "000-000-xxxx")
                profileRow(label: "Zip Code:", value: "insert_number")
            }
            .padding(.horizontal, 30)
            .padding(.vertical, 5)
            .frame(maxWidth: .infinity, alignment: .leading)


            Link("Donate Now", destination: URL(string: "https://secure.namidavidson.org/forms/namidavidsondonations")!)
            editProfileButton
            signOutButton
            deleteAccountButton
        }
        .navigationTitle("Profile")
    }
    
    var header: some View {
        HStack {
            Button(action: {
            }) {
                Image(systemName: "chevron.left")
                    .foregroundColor(.black)
            }
            Spacer()
            Text("Profile")
                .font(.title2)
                .fontWeight(.semibold)
            Spacer()
        }
        .padding(.horizontal)
        .padding(.top, 20)
    }

    var editProfileButton: some View {
        Button {
            homeScreenRouter.navigate(to: .userProfileEditView)
        } label: {
            Text("Edit Profile")
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
    
    func profileRow(label: String, value: String) -> some View {
        VStack(alignment: .leading) {
            Text(label)
                .fontWeight(.semibold)
            Text(value)
                .foregroundColor(.gray)
        }
        .padding(.vertical, 5)
    }
}

#Preview {
    UserProfileView()
        .environment(AuthenticationManager())
        .environment(HomeScreenRouter())
}
