//
//  ContentView.swift
//  NAMI
//
//  Created by Zachary Tao on 10/5/24.
//

import SwiftUI

struct AppView: View {

    init() {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.backgroundColor = UIColor.systemGray6
        tabBarAppearance.stackedLayoutAppearance.selected.iconColor = UIColor(Color.NAMITealBlue)
        tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor(Color.NAMITealBlue)]

        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
    }

    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            EventsView()
                .tabItem {
                    Label("Events", systemImage: "person.3.fill")
                }
            ChatView()
                .tabItem {
                    Label("Chat", systemImage: "message")
                }
        }
    }
}

#Preview {
    AppView()
        .environment(AuthenticationManager())
}
