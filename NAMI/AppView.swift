//
//  ContentView.swift
//  NAMI
//
//  Created by Zachary Tao on 10/5/24.
//

import SwiftUI

struct AppView: View {
    
    @State var tabSelection = 0
    @State var tabVisiblityControls = TabsControl()

    init() {
        // to customize tab bar color
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.stackedLayoutAppearance.selected.iconColor = UIColor(Color.NAMIDarkBlue)
        tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor(Color.NAMIDarkBlue)]
        
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
    }
    
    var body: some View {
        TabView(selection: $tabSelection) {

            Tab(value: 0) {
                HomeView()
                    .toolbar(tabVisiblityControls.isTabVisible ? .visible: .hidden, for: .tabBar)
            } label: {
                Label("Home", systemImage: "house")
            }

            Tab(value: 1) {
                EventsView()
                    .toolbar(tabVisiblityControls.isTabVisible ? .visible: .hidden, for: .tabBar)
            } label: {
                Label("Events", systemImage: "person.3.fill")
            }

            Tab(value: 2) {
                ChatView()
                    .toolbar(tabVisiblityControls.isTabVisible ? .visible: .hidden, for: .tabBar)
            } label: {
                Label("Chat", systemImage: "message")
            }

            if UserManager.shared.userType == .superAdmin {
                Tab(value: 3) {
                    MemberView()
                        .toolbar(tabVisiblityControls.isTabVisible ? .visible: .hidden, for: .tabBar)
                } label: {
                    Label("Member", systemImage: "checkmark.seal.fill")
                }
            }
        }
        .environment(tabVisiblityControls)
        .sensoryFeedback(.impact(weight: .heavy), trigger: tabSelection)
    }
}



#Preview {
    AppView()
        .environment(AuthenticationManager())
}
