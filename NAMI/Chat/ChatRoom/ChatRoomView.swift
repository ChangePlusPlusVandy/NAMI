//
//  ChatRoomView.swift
//  NAMI
//
//  Created by Sophie Zhuang on 1/12/25.
//

import SwiftUI
import FirebaseFirestore

struct ChatRoomView: View {
    @State var chatRoomViewModel: ChatRoomViewModel
    var chatRoomType: ChatRoomType
    @Environment(ChatAdminRouter.self) var chatAdminRouter
    @Environment(ChatUserRouter.self) var chatUserRouter

    @State var keyboardHeight: CGFloat = 0
    @State var endChatConfirmAlert = false
    @FocusState var isFocused: Bool

    init(chatRoom: ChatRoom, currentUserId: String, chatRoomType: ChatRoomType) {
        _chatRoomViewModel = State(wrappedValue: ChatRoomViewModel(chatRoom: chatRoom, currentUserId: currentUserId))
        self.chatRoomType = chatRoomType
    }

    var body: some View {
        VStack {
            ScrollViewReader { proxy in
                List {
                    ForEach(chatRoomViewModel.messages) { message in
                        MessageBubble(message: message,
                                      isCurrentUser: message.senderId == chatRoomViewModel.currentUserId)
                        .id(message.id)
                        .listRowSeparator(.hidden)
                    }
                }
                .listStyle(.plain)
                .onChange(of: chatRoomViewModel.messages.count) {
                    scrollToBottom(proxy: proxy)
                }
                .onChange(of: isFocused) {
                    if isFocused {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            scrollToBottom(proxy: proxy)
                        }
                    }
                }
                .onAppear {
                    scrollToBottom(proxy: proxy)
                }
                .scrollIndicators(.hidden)
                .scrollDismissesKeyboard(.interactively)
            }
            MessageInputView(message: $chatRoomViewModel.newMessage,
                             isFocused: $isFocused, onSend: chatRoomViewModel.sendMessage)
        }
        .ignoresSafeArea(.container, edges: .bottom)
        .confirmationDialog(
            "Are you sure you want to end this chat with \(chatRoomViewModel.chatRoom.userName)? This action cannot be undone and will delete all messages permanently.",
            isPresented: $endChatConfirmAlert,
            titleVisibility: .visible
        ) {
            Button("End Chat", role: .destructive) {
                ChatManager.shared.deleteChat(chatRoom: chatRoomViewModel.chatRoom)
                switch chatRoomType {
                case .admin:
                    chatAdminRouter.navigateToRoot()
                case .user:
                    chatUserRouter.navigateToRoot()
                }
            }
        }
        .background(Color.black.opacity(0.05).ignoresSafeArea(edges: .all))
        .navigationTitle("")
        .toolbar {
            ToolbarItem(placement: .principal) {
                switch chatRoomType {
                case .admin:
                    Text(chatRoomViewModel.chatRoom.userName)
                case .user:
                    Text("NAMI Helpline")
                }
            }

            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    endChatConfirmAlert = true
                } label: {
                    Text("End Chat")
                }
            }
        }
    }

    private func scrollToBottom(proxy: ScrollViewProxy) {
        guard let lastMessageId = chatRoomViewModel.messages.last?.id else { return }

        withAnimation(.snappy(duration: 0.3)) {
            proxy.scrollTo(lastMessageId, anchor: .bottom)
        }
    }
}

extension ChatRoomView {
    enum ChatRoomType {
        case admin
        case user
    }
}


#Preview {
    ChatRoomView(chatRoom: ChatRoom(userId: "", adminId: "", userName: "NAMI Helpline"), currentUserId: "", chatRoomType: .admin)
        .environment(ChatAdminRouter())
        .environment(ChatUserRouter())
}
