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
        NavigationStack (path: $homeScreenRouter.navPath){
            VStack{
                Button("Sign out") {
                    authManager.signOut()
                }
                .buttonStyle(.bordered)
            }
            .navigationTitle("Welcome")
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading){
                    Button{

                    } label: {
                        Image(systemName: "line.horizontal.3")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing){
                    Button{

                    } label: {
                        Image(systemName: "person.fill")
                    }
                }
            }
        }
    }
}


#Preview {
        HomeView()
        .environment(AuthenticationManager())
        .tint(.primary)
}
