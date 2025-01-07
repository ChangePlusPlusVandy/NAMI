//
//  UserProfileEditView.swift
//  NAMI
//
//  Created by Zachary Tao on 11/17/24.
//

import SwiftUI

struct UserProfileEditView: View {
    @Environment(HomeScreenRouter.self) var homeScreenRouter
    @State var user: NamiUser = (UserManager.shared.getCurrentUser() ?? NamiUser(userType: .member, firstName: "", lastName: "", email: "", phoneNumber: "", zipCode: "", registeredEventsIds: []))
    var body: some View {
        ScrollView (showsIndicators: false) {
            VStack(alignment: .leading, spacing: 35) {
                Spacer(minLength: 20)
                UserInfoInputField(text: "First Name", field: $user.firstName)

                UserInfoInputField(text: "Last Name", field: $user.lastName)

                UserInfoInputField(text: "Email", field: $user.email)

                UserInfoInputField(text: "Phone Number", field: $user.phoneNumber, numPad: true)

                UserInfoInputField(text: "ZIP Code", field: $user.zipCode, numPad: true)
            }
        }
        .scrollDismissesKeyboard(.interactively)
        .navigationTitle("Edit Profile")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    homeScreenRouter.navigateBack()
                } label: {
                    Text("Cancel")
                        .foregroundStyle(Color.NAMIDarkBlue)
                }
            }

            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    Task {
                        await UserManager.shared.updateUserInfo(updatedUser: user)
                    }
                    homeScreenRouter.navigateBack()
                } label: {
                    Text("Save")
                        .foregroundStyle(Color.NAMIDarkBlue)
                }
            }
        }
    }
}

#Preview {
    UserProfileEditView()
        .environment(HomeScreenRouter())
}
