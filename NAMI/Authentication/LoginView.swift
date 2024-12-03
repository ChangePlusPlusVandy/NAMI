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
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        VStack {
            Spacer()
            Image("NAMILogo")
                .resizable()
                .scaledToFit()
                .frame(width: 300, height: 300)
            Spacer()
            GoogleSignInButton
                .padding(.vertical)
            AppleSignInButton
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
            HStack(alignment: .center, spacing: 0) {
                Image("Google")
                Text("Sign in with Google")
            }
            .padding()
            .frame(maxWidth: .infinity)
            .frame(height: 35)
        }
        .foregroundStyle(.primary)
        .buttonStyle(.bordered)
        .cornerRadius(10)
    }

    var AppleSignInButton: some View {
        SignInWithAppleButton(.signIn) { request in
            authManager.handleSignInWithAppleRequest(request)
        } onCompletion: { result in
            authManager.handleSignInWithAppleCompletion(result)
        }
        .signInWithAppleButtonStyle(colorScheme == .light ? .black : .white)
        .frame(maxWidth: .infinity)
        .frame(height: 50)
        .cornerRadius(10)
    }
}

#Preview {
    LoginView()
        .environment(AuthenticationManager())
}
