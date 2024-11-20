//
//  HomeView.swift
//  NAMI
//
//  Created by Zachary Tao on 11/10/24.
//

import SwiftUI

struct HomeView: View {
    @Environment(AuthenticationManager.self) var authManager
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
                        .toolbar(.hidden, for: .tabBar)
                case .userProfileEditView:
                    UserProfileEditView()
                        .environment(homeScreenRouter)
                        .toolbar(.hidden, for: .tabBar)
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
        ToolbarItem(placement: .topBarTrailing){
            Button{
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
}
