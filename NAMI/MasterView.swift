//
//  ContentView.swift
//  NAMI
//
//  Created by Zachary Tao on 10/5/24.
//

import SwiftUI

struct MasterView: View {
    @State var router = Router()
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
                    Label("Events", systemImage: "message")
                }
        }
        .tint(.primary)
    }
}

#Preview {
    MasterView()
}
