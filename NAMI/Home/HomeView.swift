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
                    .franklinGothic(.bold, 34)
                    .padding()
                Text("My Upcoming Events")
                    .proximaNova(.regular, 16)
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
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("")
                        .franklinGothic(.regular, 28)
                }
            }
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
        ToolbarItem(placement: .navigationBarLeading){
            Button{

            } label: {
                Image(systemName: "line.horizontal.3")
            }
        }
        ToolbarItem(placement: .navigationBarLeading){
            Text("NAMI")
                .franklinGothic(.bold, 22)
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
