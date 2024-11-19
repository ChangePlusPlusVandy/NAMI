//
//  SignUpView.swift
//  NAMI
//
//  Created by Zachary Tao on 11/10/24.
//

import SwiftUI
import Combine

struct LoginView: View {
    @Environment(AuthenticationManager.self) var authManager
    var body: some View {
        VStack {
            Spacer()
            Image("NAMILogo")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
            Spacer()
            GoogleSignInButton
            Spacer()
        }
        .padding()
    }

    var GoogleSignInButton: some View {
        Button{
            Task {
                _ = await authManager.signInWithGoogle()
            }
        } label: {
            HStack(alignment: .center){
                Image("Google")
                Text("Sign in with Google")
                    .proximaNova()
            }
            .frame(maxWidth: .infinity)
        }
        .frame(height: 50)
        .foregroundStyle(.primary)
        .buttonStyle(.bordered)
        .cornerRadius(10)
    }
}

#Preview {
    LoginView()
        .environment(AuthenticationManager())
}
