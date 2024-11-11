//
//  SignUpView.swift
//  NAMI
//
//  Created by Zachary Tao on 11/10/24.
//

import SwiftUI
import Combine

struct SignUpView: View {
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

    var GoogleSignInButton: some View{
        Button{
            Task {
                if await authManager.signInWithGoogle() == true {
                }
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
}

#Preview {
    SignUpView()
        .environment(AuthenticationManager())
}
