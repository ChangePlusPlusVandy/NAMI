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
    @Environment(TabsControl.self) var tabVisibilityControls

    @FirestoreQuery(collectionPath: "chatRequests",
                    predicates: [.order(by: "requestTime", descending: false)],
                    animation: .default) var chatRequests: [ChatRequest]

    @FirestoreQuery(collectionPath: "chatRooms",
                    predicates: [.order(by: "lastMessageTimestamp", descending: true),
                                 .isEqualTo("adminId", UserManager.shared.userID)
                                ],
                    animation: .default) var chatRooms: [ChatRoom]

    var body: some View {
        NavigationStack(path: $chatAdminRouter.navPath) {
            List {
                Section(header: Text("New Chats").font(.title3)) {
                    ForEach(chatRequests) { chatRequest in
                        ChatRequestCell(chatRequest: chatRequest)
                    }
                }
                
                Section(header: Text("Active Chats").font(.title3)) {
                    ForEach(chatRooms) { chatRoom in
                        ChatRoomCell(chatRoom: chatRoom)
                    }
                }
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: ChatAdminRouter.Destination.self) { destination in
                switch destination {
                case .chatRoomView(let chatRoom):
                    ChatRoomView(chatRoom: chatRoom, currentUserId: UserManager.shared.userID, chatRoomType: .admin)
                        .environment(chatAdminRouter)
                        .environment(ChatUserRouter())
                }
            }
            .environment(chatAdminRouter)
            .environment(tabVisibilityControls)
            .onAppear {
                tabVisibilityControls.makeVisible()
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("NAMI Helpline")
                }
            }
        }
    }
}

#Preview {
    ChatAdminHomeView()
        .environment(TabsControl())
}
