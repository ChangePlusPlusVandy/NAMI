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
    @State var homeScreenRouter = HomeScreenRouter()
    @State var userProfileRouter = HomeScreenRouter()


    init() {
        // to customize tab bar color
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.stackedLayoutAppearance.selected.iconColor = UIColor(Color.NAMIDarkBlue)
        tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor(Color.NAMIDarkBlue)]
        
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        
        // Set initial tab based on user type
        if UserManager.shared.userType == .superAdmin {
            _tabSelection = State(initialValue: 3) // Member tab
        } else if UserManager.shared.userType == .admin {
            _tabSelection = State(initialValue: 1) // Events tab
        }
    }
    
    var body: some View {
        TabView(selection: $tabSelection) {
            if UserManager.shared.userType == .member {
                Tab(value: 0) {
                    HomeView()
                        .environment(homeScreenRouter)
                        .toolbar(tabVisiblityControls.isTabVisible ? .visible: .hidden, for: .tabBar)
                } label: {
                    Label("Home", systemImage: "house")
                }
            }

            if UserManager.shared.userType == .superAdmin {
                Tab(value: 3) {
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

            if UserManager.shared.userType != .member {
                Tab(value: 4) {
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
        .sensoryFeedback(.impact(weight: .heavy), trigger: tabSelection)
    }
}



#Preview {
    AppView()
        .environment(AuthenticationManager())
}
