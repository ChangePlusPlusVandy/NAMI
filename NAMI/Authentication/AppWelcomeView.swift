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
            VStack {
                Spacer()
                welcomeTitle
                Spacer()
                memberButton
                volunteerButton
                adminButton
                Spacer()
            }
            .navigationTitle("")
        }
    }

    var welcomeTitle: some View {
        VStack (alignment: .leading, spacing: 50){
            Text("Welcome to NAMI")
                .font(.system(size: 40, weight: .bold))
            Text("Are you a...")
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
                .bold()
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
                .bold()
                .foregroundStyle(.black)
                .frame(width: 300, height: 50)
                .background(Color.white)
                .cornerRadius(10)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.primary, lineWidth: 1.5))
        }
    }

    var volunteerButton: some View {
        Button {

        } label: {
            Text("Volunteer")
                .bold()
                .foregroundStyle(.white)
                .frame(width: 300, height: 50)
                .background(Color.NAMIGreen)
                .cornerRadius(10)
        }
    }
}

#Preview {
    AppWelcomeView()
        .environment(AuthenticationManager())
}
