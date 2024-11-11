//
//  ContentView.swift
//  NAMI
//
//  Created by Zachary Tao on 10/5/24.
//

import SwiftUI

struct AppView: View {
    @State var router = Router()
    @Environment(AuthenticationManager.self) var authManager
    var body: some View {
        TabView {
            HomeView()
                .environment(authManager)
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            EventsView()
                .tabItem {
                    Label("Events", systemImage: "person.3.fill")
                }
            ChatView()
                .tabItem {
                    Label("Events", systemImage: "message")
                }
        }
        .tint(.primary)
    }
}

#Preview {
    MasterView()
        .environment(AuthenticationManager())
}
