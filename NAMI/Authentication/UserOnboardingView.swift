//
//  UserOnboardingView.swift
//  NAMI
//
//  Created by Zachary Tao on 11/11/24.
//

import SwiftUI


struct UserOnboardingView: View {
    @State var user = NamiUser(userType: .member, firstName: "", lastName: "", email: "", phoneNumber: "", zipCode: "")
//    @Binding var user: NamiUser
    @Environment(AuthenticationManager.self) var authManager
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack (alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/) {
            Spacer()
                .frame(height: 50)
            Text("Member Sign Up")
                .font(.title)
            Spacer()
                .frame(height: 35)
            HStack {
                Spacer()
                    .frame(width: 15)
                Text("First Name: ")
                    .bold()
                Spacer()
            }
            HStack {
                Spacer()
                TextField("First Name", text: $user.firstName)
                    .frame(width: 365, height: 50)
                    .padding(5)
                    .background {
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.gray, lineWidth: 5)
                            .frame(width: 375, height: 65)
                            .foregroundStyle(.gray)
                            .opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)
                    }
                Spacer()
            }
            Spacer()
                .frame(height: 10)
            HStack {
                Spacer()
                    .frame(width: 15)
                Text("Last Name: ")
                    .bold()
                Spacer()
            }
            HStack {
                Spacer()
                TextField("Last Name", text: $user.lastName)
                    .frame(width: 365, height: 50)
                    .padding(5)
                    .background {
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.gray, lineWidth: 5)
                            .frame(width: 375, height: 65)
                            .foregroundStyle(.gray)
                            .opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)
                    }
                Spacer()
            }
            Spacer()
                .frame(height: 10)
            HStack {
                Spacer()
                    .frame(width: 15)
                Text("Email: ")
                    .bold()
                Spacer()
            }
            HStack {
                Spacer()
                TextField("Email", text: $user.email)
                    .frame(width: 365, height: 50)
                    .padding(5)
                    .background {
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.gray, lineWidth: 5)
                            .frame(width: 375, height: 65)
                            .foregroundStyle(.gray)
                            .opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)
                    }
                Spacer()
            }
            Spacer()
                .frame(height: 10)
            HStack {
                Spacer()
                    .frame(width: 15)
                Text("Phone number: ")
                    .bold()
                Spacer()
            }
            HStack {
                Spacer()
                TextField("Phone Number", text: $user.phoneNumber)
                    .frame(width: 365, height: 50)
                    .padding(5)
                    .background {
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.gray, lineWidth: 5)
                            .frame(width: 375, height: 65)
                            .foregroundStyle(.gray)
                            .opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)
                    }
                Spacer()
            }
            Spacer()
                .frame(height: 10)
            HStack {
                Spacer()
                    .frame(width: 15)
                Text("Zipcode: ")
                    .bold()
                Spacer()
            }
            HStack {
                Spacer()
                TextField("Zipcode", text: $user.zipCode)
                    .frame(width: 365, height: 50)
                    .padding(5)
                    .background {
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.gray, lineWidth: 5)
                            .frame(width: 375, height: 65)
                            .foregroundStyle(.gray)
                            .opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)
                    }
                Spacer()
            }
            Spacer()
                .frame(height: 40)
            HStack {
                Spacer()
                Button {
                    Task {
                        await UserManager.shared.createNewUser(newUser: NamiUser.errorUser)
                    }
                    authManager.isFirstTimeSignIn = false
                } label: {
                    Text("Submit")
                        .font(.title2)
                }
                Spacer()
            }
        }
    }
}


#Preview {
    UserOnboardingView()
        .environment(AuthenticationManager())
}
