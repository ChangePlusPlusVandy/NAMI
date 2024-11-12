//
//  AppWelcomeView.swift
//  NAMI
//
//  Created by Zachary Tao on 11/11/24.
//

import SwiftUI

struct AppWelcomeView: View {
    @Environment(AuthenticationManager.self) var authManager
    var body: some View {
        NavigationStack {
            VStack{
                Spacer()
                welcomeTitle
                Spacer()
                memberButton
                adminButton
                Spacer()
            }
        }
    }

    var welcomeTitle: some View {
        VStack (alignment: .leading, spacing: 50){
            Text("Welcome")
                .font(.system(size: 40, weight: .bold))
            Text("Are you a...")
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(60)
    }

    var memberButton: some View {
        Button{
            authManager.authenticationState = .loginStage
        } label: {
            Text("Member")
                .frame(width: 300, height: 50)
                .foregroundStyle(.white)
                .background(Color.NAMIDarkBlue)
                .cornerRadius(10)
        }
    }

    var adminButton: some View {
        Button {

        } label: {
            Text("Admin")
                .foregroundStyle(.black)
                .frame(width: 300, height: 50)
                .cornerRadius(10)
                .background(Color.white)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.primary, lineWidth: 1.5))
        }
    }
}

#Preview {
    AppWelcomeView()
        .environment(AuthenticationManager())
}
