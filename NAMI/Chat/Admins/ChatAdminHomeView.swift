//
//  ChatAdminHomeView.swift
//  NAMI
//
//  Created by Zachary Tao on 2/18/25.
//

import SwiftUI

struct ChatAdminHomeView: View {
    @State var chatAdminRouter = ChatAdminRouter()
    var body: some View {
        NavigationStack(path: $chatAdminRouter.navPath) {
            VStack {
                ScrollView {
                    Text("New Chats")
                        .font(.title)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top)

                    Text("Active Chats")
                        .font(.title)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding(.horizontal)
            .navigationTitle("HelpLine")
        }
    }
}

#Preview {
    ChatAdminHomeView()
}
