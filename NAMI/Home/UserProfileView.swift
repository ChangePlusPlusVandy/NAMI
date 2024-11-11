//
//  UserProfileView.swift
//  NAMI
//
//  Created by Zachary Tao on 11/10/24.
//

import SwiftUI

struct UserProfileView: View {
    @Environment(AuthenticationManager.self) var authManager
    var body: some View {
        VStack{
            Button("Sign Out") {
                authManager.signOut()
            }.buttonStyle(.bordered)
        }
    }
}

#Preview {
    UserProfileView()
}
