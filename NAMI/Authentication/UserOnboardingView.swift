//
//  UserOnboardingView.swift
//  NAMI
//
//  Created by Zachary Tao on 11/11/24.
//

import SwiftUI


struct UserOnboardingView: View {
    @State var user = NamiUser(userType: .member, firstName: "", lastName: "", email: "", phoneNumber: "", zipCode: "")
    @Environment(AuthenticationManager.self) var authManager
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {

            Text("Member Sign Up")
                .font(.title)
                .bold()

            Text("First Name: ")
                .bold()

            TextField("First Name", text: $user.firstName)
                .textFieldStyle(CustemOnboardingTextfieldStyle())


            Text("Last Name: ")
                .bold()


            TextField("Last Name", text: $user.lastName)
                .textFieldStyle(CustemOnboardingTextfieldStyle())

            Text("Email: ")
                .bold()


            TextField("Email", text: $user.email)
                .textFieldStyle(CustemOnboardingTextfieldStyle())


            Text("Phone number: ")
                .bold()


            TextField("Phone Number", text: $user.phoneNumber)
                .textFieldStyle(CustemOnboardingTextfieldStyle())

            Text("Zipcode: ")
                .bold()


            TextField("Zipcode", text: $user.zipCode)
                .textFieldStyle(CustemOnboardingTextfieldStyle())


            Button {
                Task {
                    await UserManager.shared.createNewUser(newUser: NamiUser.errorUser)
                }
                authManager.isFirstTimeSignIn = false
            } label: {
                Text("Confirm")
                    .font(.title2)
            }
            .frame(maxWidth: .infinity, alignment: .center)

        }.padding()
    }
}

struct CustemOnboardingTextfieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.gray, lineWidth: 2)
            )
    }
}


#Preview {
    UserOnboardingView()
        .environment(AuthenticationManager())
}
