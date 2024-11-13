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
    
    @State var disable = true

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 21) {
                
                Text("Member Sign Up")
                    .font(.title)
                    .bold()
                
                SignUpField(text: "First Name", variable: $user.firstName).body
                
                SignUpField(text: "Last Name", variable: $user.lastName).body
                
                SignUpField(text: "Email", variable: $user.email).body
                
                SignUpField(text: "Phone Number", variable: $user.phoneNumber, numPad: true).body
                
                SignUpField(text: "Zipcode", variable: $user.zipCode, numPad: true).body
                
                Button {
                    Task {
                        await UserManager.shared.createNewUser(newUser: NamiUser.errorUser)
                    }
                    authManager.isFirstTimeSignIn = false
                } label: {
                    Text("Confirm")
                        .font(.title2)
                }
                .disabled(user.firstName == "" ||
                          user.lastName == "" ||
                          user.email == "" ||
                          user.phoneNumber == "" ||
                          user.zipCode == "")
                .frame(maxWidth: .infinity, alignment: .center)
                
            }.padding()
        }
    }
    private struct SignUpField {
        var text: String
        var variable: Binding<String>
        var numPad: Bool = false
        var body: some View {
            VStack (alignment: .leading, spacing: 21) {
                Text("\(text): ")
                    .bold()
                
                
                TextField("\(text)", text: variable)
                    .keyboardType(numPad ? .numberPad : .default)
                    .textFieldStyle(CustemOnboardingTextfieldStyle())
         
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
