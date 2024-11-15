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
                    .padding(.bottom, 50)
                Text("My Upcoming Events")
                    .font(.callout)
                    .foregroundStyle(.secondary)
                List{

                }
            }
            .padding()
            .toolbar {homeViewToolBar}
            .navigationTitle("")
            .navigationDestination(for: HomeScreenRouter.Destination.self) { destination in
                switch destination {
                case .userProfileView:
                    UserProfileView()
                        .environment(homeScreenRouter)

                }
            }
        }
    }

    @ToolbarContentBuilder
    var homeViewToolBar: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading){
            Button{

            } label: {
                Image(systemName: "line.horizontal.3")
            }
        }
        ToolbarItem(placement: .navigationBarLeading){
            Text("NAMI")
                .font(.title2.bold())
        }
        ToolbarItem(placement: .navigationBarTrailing){
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
