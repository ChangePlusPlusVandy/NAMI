//
//  ChatAdminHomeView.swift
//  NAMI
//
//  Created by Zachary Tao on 2/18/25.
//

import SwiftUI
import FirebaseFirestore

struct ChatAdminHomeView: View {
    @State var chatAdminRouter = ChatAdminRouter()
    
    @FirestoreQuery(collectionPath: "chatRequests",
                    predicates: [.order(by: "requestTime", descending: false)],
                    animation: .default) var chatRequests: [ChatRequest]
    
    var body: some View {
        NavigationStack(path: $chatAdminRouter.navPath) {
            List {
                Section(header: Text("New Chats").font(.title3)) {
                    ForEach(chatRequests) { chatRequest in
                        ChatRequestCell(chatRequest: chatRequest)
                    }
                }
                
                Section(header: Text("Active Chats").font(.title3)) {
                    
                }
            }
            //.listStyle(.plain)
            .navigationTitle("NAMI HelpLine")
        }
    }
}

#Preview {
    ChatAdminHomeView()
}
