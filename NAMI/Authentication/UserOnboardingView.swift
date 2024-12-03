//
//  UserOnboardingView.swift
//  NAMI
//
//  Created by Zachary Tao on 11/11/24.
//

import SwiftUI

struct UserOnboardingView: View {
    @State var newUser = NamiUser(userType: .member, firstName: "", lastName: "", email: "", phoneNumber: "", zipCode: "")
    @Environment(AuthenticationManager.self) var authManager
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ScrollView (showsIndicators: false) {
            VStack(alignment: .leading, spacing: 21) {

                Text("Member Sign Up")
                    .font(.title.bold())
                    .padding(20)

                UserInfoInputField(text: "First Name", field: $newUser.firstName)

                UserInfoInputField(text: "Last Name", field: $newUser.lastName)

                UserInfoInputField(text: "Email", field: $newUser.email)

                UserInfoInputField(text: "Phone Number", field: $newUser.phoneNumber, numPad: true)

                UserInfoInputField(text: "ZIP Code", field: $newUser.zipCode, numPad: true)

                Button {
                    Task {
                        newUser.userType = authManager.userType
                        await UserManager.shared.createNewUser(newUser: newUser)
                    }
                    authManager.isFirstTimeSignIn = false
                } label: {
                    Text("Confirm")
                        .font(.title3)
                        .frame(width: 300, height: 50)
                        .foregroundStyle(.white)
                        .background(Color.NAMIDarkBlue)
                        .cornerRadius(10)
                        .padding(40)
                        .opacity(isConfirmButtonDisabled ? 0.6 : 1.0)
                }
                .disabled(isConfirmButtonDisabled)
                .frame(maxWidth: .infinity, alignment: .center)
            }
        }.scrollDismissesKeyboard(.interactively)
    }

    var isConfirmButtonDisabled : Bool {
        newUser.firstName == "" ||
        newUser.lastName == "" ||
        newUser.email == "" ||
        newUser.phoneNumber == "" ||
        newUser.zipCode == ""
    }
}

struct UserInfoInputField: View {
    var text: String
    @Binding var field: String
    var numPad: Bool = false
    var body: some View {
        VStack (alignment: .leading, spacing: 8) {
            Text("\(text): ")
                .bold()

            TextField("", text: $field)
                .frame(height: 50)
                .keyboardType(numPad ? .numberPad : .default)
                .padding(.horizontal, 10)
                .overlay{
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.secondary, lineWidth: 1)
                }
        }.padding(.horizontal, 20)
    }
}

#Preview {
    UserOnboardingView()
        .environment(AuthenticationManager())
}
