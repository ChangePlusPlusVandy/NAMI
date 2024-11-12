//
//  UserOnboardingView.swift
//  NAMI
//
//  Created by Zachary Tao on 11/11/24.
//

import SwiftUI

struct UserOnboardingView: View {
    @Environment(AuthenticationManager.self) var authManager
    var body: some View {
        VStack{
            backButton
            // TODO: Create a form for user onboarding
            Spacer()
            Button("Confirm") {
                // dummy data for now
                Task {
                    await UserManager.shared.createNewUser(newUser: NamiUser.errorUser)
                }
                authManager.authenticationState = .authenticated
            }
            Spacer()
        }
    }

    var backButton: some View {
        Button{
            authManager.signOut()
            authManager.authenticationState = .welcomeStage
        } label: {
            Image(systemName: "chevron.left")
                .font(.title3.bold())
                .foregroundStyle(.black)
        }.frame(maxWidth: .infinity, alignment: .leading)
            .padding()
    }
}

#Preview {
    UserOnboardingView()
}
