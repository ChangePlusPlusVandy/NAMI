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
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("")
                        .franklinGothic(.regular, 28)
                }
            }
        }
    }

    var welcomeTitle: some View {
        VStack (alignment: .leading, spacing: 50){
            Text("Welcome")
                .proximaNova(.bold, 40)
            Text("Are you a...")
                .proximaNova()
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(60)
    }

    var memberButton: some View {
        NavigationLink {
            LoginView()
                .environment(authManager)
        } label: {
            Text("Member")
                .proximaNova()
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
                .proximaNova()
                .foregroundStyle(.black)
                .frame(width: 300, height: 50)
                .background(Color.white)
                .cornerRadius(10)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.primary, lineWidth: 1.5))
        }
    }
}

#Preview {
    AppWelcomeView()
        .environment(AuthenticationManager())
}
