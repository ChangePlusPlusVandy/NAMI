//
//  ContentView.swift
//  NAMI
//
//  Created by Zachary Tao on 10/5/24.
//

import SwiftUI

struct AppView: View {
    
    @State var tabVisiblityControls = TabsControl()
    @State var userProfileRouter = HomeScreenRouter()

    init() {
        // to customize tab bar color
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.stackedLayoutAppearance.selected.iconColor = UIColor(Color.NAMIDarkBlue)
        tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor(Color.NAMIDarkBlue)]
        
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
    }
    
    var body: some View {
        TabView(selection: $tabVisiblityControls.tabSelection) {
            if UserManager.shared.userType == .member {
                Tab(value: 0) {
                    HomeView()
                        .toolbar(tabVisiblityControls.isTabVisible ? .visible: .hidden, for: .tabBar)
                } label: {
                    Label("Home", systemImage: "house")
                }
            } else if UserManager.shared.userType == .superAdmin {
                Tab(value: 0) {
                    MemberView()
                        .toolbar(tabVisiblityControls.isTabVisible ? .visible: .hidden, for: .tabBar)
                } label: {
                    Label("Member", systemImage: "checkmark.seal.fill")
                }
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

            if UserManager.shared.isVolunteerOrAdmin() {
                Tab(value: 3) {
                    NavigationStack(path: $userProfileRouter.navPath) {
                        UserProfileView()
                            .environment(userProfileRouter)
                            .toolbar(tabVisiblityControls.isTabVisible ? .visible: .hidden, for: .tabBar)
                            .navigationDestination(for: HomeScreenRouter.Destination.self) { destination in
                                if destination == .userProfileEditView {
                                    UserProfileEditView()
                                        .environment(userProfileRouter)
                                }
                            }
                    }
                } label: {
                    Label("Profile", systemImage: "person.fill")
                }
            }
        }
        .environment(tabVisiblityControls)
        .sensoryFeedback(.impact(weight: .heavy), trigger: tabVisiblityControls.tabSelection)
    }
}



#Preview {
    AppView()
        .environment(AuthenticationManager())
}
