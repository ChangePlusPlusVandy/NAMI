//
//  SignUpView.swift
//  NAMI
//
//  Created by Zachary Tao on 11/10/24.
//

import SwiftUI
import Combine
import AuthenticationServices

struct LoginView: View {
    @Environment(AuthenticationManager.self) var authManager
    var body: some View {
        VStack {
            Spacer()
            Image("NAMILogo")
                .resizable()
                .scaledToFit()
                .frame(width: 300, height: 300)
            Spacer()
            GoogleSignInButton
            signInWithAppleButton
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
            }
            .frame(maxWidth: .infinity)
        }
        .frame(height: 50)
        .foregroundStyle(.primary)
        .buttonStyle(.bordered)
        .cornerRadius(10)
    }
    
    var signInWithAppleButton: some View {
            SignInWithAppleButton(.signIn) { request in
                request.requestedScopes = [.fullName, .email]
            } onCompletion: { _ in
                Task {
                    _ = await authManager.signInWithApple()
                }
            }
            .frame(height: 50)
            .cornerRadius(10)
        }
}

#Preview {
    LoginView()
        .environment(AuthenticationManager())
}
