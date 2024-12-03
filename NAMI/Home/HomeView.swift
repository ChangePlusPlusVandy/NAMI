//
//  HomeView.swift
//  NAMI
//
//  Created by Zachary Tao on 11/10/24.
//

import SwiftUI

struct HomeView: View {

    @Environment(AuthenticationManager.self) var authManager
    @Environment(TabsControl.self) var tabVisibilityControls
    @State var homeScreenRouter = HomeScreenRouter()

    var body: some View {
        NavigationStack(path: $homeScreenRouter.navPath) {
            VStack (alignment: .leading){
                Text("Welcome")
                    .font(.largeTitle.bold())
                    .padding([.bottom, .horizontal])
                    .padding(.top, 10)
                Text("My Upcoming Events")
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .padding()
                List {
                    EventCardView(event: Event.dummyEvent)
                        .listRowSeparator(.hidden)
                }
                .ignoresSafeArea()
                .listStyle(.plain)
                .scrollIndicators(.hidden)
            }
            .toolbar {homeViewToolBar}
            .navigationTitle("")
            .navigationDestination(for: HomeScreenRouter.Destination.self) { destination in
                switch destination {
                case .userProfileView:
                    UserProfileView()
                        .environment(homeScreenRouter)
                case .userProfileEditView:
                    UserProfileEditView()
                        .environment(homeScreenRouter)
                case .adminEventCreationView:
                    EventCreationView()
                        .environment(homeScreenRouter)
                        .environment(EventsViewRouter())
                }
            }
            .onChange(of: homeScreenRouter.navPath) {
                if homeScreenRouter.navPath.isEmpty {
                    tabVisibilityControls.makeVisible()
                }
            }
        }
    }

    @ToolbarContentBuilder
    var homeViewToolBar: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading){
            Image("NAMIHeaderLogo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
        }

        if UserManager.shared.userType == .admin {
            ToolbarItem(placement: .topBarTrailing){
                Button{
                    tabVisibilityControls.makeHidden()
                    homeScreenRouter.navigate(to: .adminEventCreationView)
                } label: {
                    Image(systemName: "plus.app")
                }
            }
        }

        ToolbarItem(placement: .topBarTrailing) {
            Button {
                tabVisibilityControls.makeHiddenNoAnimation()
                homeScreenRouter.navigate(to: .userProfileView)
            } label: {
                Image(systemName: "person.fill")
            }
        }
    }
}


#Preview {
    HomeView()
        .environment(AuthenticationManager())
        .environment(TabsControl())
}
