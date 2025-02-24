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
    @Environment(TabsControl.self) var tabVisibilityControls
    @State private var showDeleteAccountAlert = false
    @State private var showUserTypePopover = false

    var body: some View {
        ZStack(alignment: .center) {
            ScrollView {
                VStack (alignment: .leading, spacing: 25) {
                    profileRow(label: "First Name:", value: UserManager.shared.currentUser?.firstName)
                    profileRow(label: "Last Name:", value: UserManager.shared.currentUser?.lastName)
                    profileRow(label: "Email:", value: UserManager.shared.currentUser?.email)
                    profileRow(label: "Phone:", value: UserManager.shared.currentUser?.phoneNumber)
                    profileRow(label: "Zip Code:", value: UserManager.shared.currentUser?.zipCode)
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("User Type")
                                .fontWeight(.semibold)
// MARK: Temporarily disable
//                            if UserManager.shared.userType == .member {
//                                Button {
//                                    withAnimation(.snappy(duration: 0.2)) {
//                                        showUserTypePopover.toggle()
//                                    }
//                                } label: {
//                                    Image(systemName: "info.circle")
//                                }
//                                .sensoryFeedback(.impact(weight: .heavy), trigger: showUserTypePopover)
//                            }
                        }
                        Text(UserManager.shared.currentUser?.userType.description ?? "error")
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.horizontal, 20)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 40)
                .padding(.bottom, 20)

                VStack (alignment: .center, spacing: 15) {
                    donateButton
                    signOutButton
                    if UserManager.shared.userType != .superAdmin {
                        deleteAccountButton
                    }
                }
            }

            if showUserTypePopover {
                ZStack {
                    Color.black.opacity(0.4)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            showUserTypePopover.toggle()
                        }
                        .transition(.opacity)
                    PopOverMenu()
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    homeScreenRouter.navigate(to: .userProfileEditView)
                    tabVisibilityControls.makeHidden()
                } label: {
                    Text("Edit")
                }
            }
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if UserManager.shared.isAdmin() {
                tabVisibilityControls.makeVisibleNoAnimation()
            }
        }
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
            UserManager.shared.stopListeningForUserChanges()
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


struct PopOverMenu: View {
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Button {
            } label: {
                HStack {

                    VStack(alignment: .leading) {
                        Text("Apply to Become a Volunteer")
                            .font(.headline)
                            .fontWeight(.semibold)

                        Text("Join our team and make a difference by volunteering your time.")
                            .font(.caption)
                            .multilineTextAlignment(.leading)
                    }
                    Spacer()
                    Image(systemName: "chevron.compact.forward")
                }
            }

            Rectangle()
                .fill(Color.gray)
                .frame(height: 1)
                .padding(.horizontal)

            Button {
                // Action for requesting admin approval
            } label: {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Request Admin Approval")
                            .font(.headline)
                            .fontWeight(.semibold)

                        Text("Get access to admin privileges by submitting your request.")
                            .font(.caption)
                            .multilineTextAlignment(.leading)
                    }
                    Spacer()
                    Image(systemName: "chevron.compact.forward")
                }
            }
        }
        .padding()
        .background(Color(uiColor: UIColor.systemBackground))
        .cornerRadius(16)
        .padding(.horizontal, 30)
    }
}
