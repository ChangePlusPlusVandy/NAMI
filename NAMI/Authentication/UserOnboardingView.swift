//
//  UserOnboardingView.swift
//  NAMI
//
//  Created by Zachary Tao on 11/11/24.
//

import SwiftUI

struct UserOnboardingView: View {
    @Environment(AuthenticationManager.self) var authManager
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack {
            //backButton
            // TODO: Create a form for user onboarding
            Text("Member Sign Up")
                .font(.title.bold())
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            Spacer()
            Button("Confirm") {
                // dummy data for now
                Task {
                    await UserManager.shared.createNewUser(newUser: NamiUser.errorUser)
                }
                authManager.isFirstTimeSignIn = false
            }
            Spacer()
        }
    }
}

#Preview {
    UserOnboardingView()
        .environment(AuthenticationManager())
}
