//
//  ChatRequestView.swift
//  NAMI
//
//  Created by Zachary Tao on 2/19/25.
//

import SwiftUI

struct ChatRequestView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(ChatUserRouter.self) var chatUserRouter
    @Environment(TabsControl.self) var tabVisibilityControls
    @State private var messageText: String = ""
    @FocusState private var keyboardFocused: Bool


    var body: some View {
        ScrollView {
            VStack {
                Text("Need someone to talk to?")
                    .font(.title2)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding(.vertical)

                Text("Tell us what's going on, and a caring NAMI volunteer will be here to listen and chat with you soon.")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                    .padding()

                TextEditor(text: $messageText)
                    .frame(height: 150)
                    .padding(8)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(.systemGray6))
                    )
                    .padding(.horizontal)
                    .focused($keyboardFocused)


                Button {
                    let userFirstName = UserManager.shared.currentUser?.firstName ?? ""
                    let userLastName = UserManager.shared.currentUser?.lastName ?? ""
                    let userName = "\(userFirstName) \(userLastName)"
                    let chatRequest = ChatRequest(requestId: UUID().uuidString, userName: userName, userId: UserManager.shared.userID, requestTime: Date(), requestReason: messageText)
                    chatUserRouter.navigate(to: .chatWaitingView)
                    ChatManager.shared.sendChatRoomRequest(chatRequest: chatRequest)
                } label: {
                    Text("Send Request")
                        .padding(.horizontal, 40)
                        .padding(.vertical, 10)
                        .background(Color.NAMIDarkBlue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
            }
        }
        .onAppear {
            keyboardFocused = true
            tabVisibilityControls.makeHidden()
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Cancel") {
                    chatUserRouter.navigateBack()
                }
            }
        }
    }
}

#Preview {
    ChatRequestView()
        .environment(TabsControl())
        .environment(ChatUserRouter())
}
