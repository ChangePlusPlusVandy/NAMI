//
//  ChatWaitingView.swift
//  NAMI
//
//  Created by stevenysy on 2/10/25.
//

import SwiftUI

struct ChatWaitingView: View {
    @State private var rotation: Double = 0
    @State private var showAlert = false
    @Environment(\.colorScheme) var colorScheme

    @Environment(ChatUserManager.self) var chatUserManager
    @Environment(ChatUserRouter.self) var chatUserRouter

    var body: some View {
        VStack {
            Spacer()
            Spacer()

            Image("NAMILogo")
                .resizable()
                .scaledToFit()
                .frame(width: 250)

            Spacer()

            if chatUserManager.isCurrentChatRequestRemoved {
                Text("Your chat request has been removed by the admin. You can tap 'Cancel Chat' to exit and create a new request if needed.")
                    .foregroundStyle(.red)
                    .multilineTextAlignment(.center)
                    .padding()
            } else {
                loadingSpinner()
                    .frame(width: 40)

                Text("Connecting...")
                    .fontWeight(.light)
                    .padding(.top, 5)
            }
            Spacer()

            Text("If you are experiencing a mental health crisis, please call or text 988, available 24/7/365")
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding()
            cancelChatButton()
                .padding(.bottom, 40)
        }
        .alert("Are you sure you want to cancel your chat request?", isPresented: $showAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Exit", role: .destructive) {
                chatUserManager.deleteCurrentChatRoomRequest()
                chatUserRouter.navigateToRoot()
            }
        } message: {
            Text("You're up next soon")
        }
        .navigationBarBackButtonHidden(true)
        .ignoresSafeArea(.all)
        .task {
            chatUserManager.listenForChatRoomCreation { chatRoom in
                chatUserRouter.navigate(to: .chatRoomView(chatRoom: chatRoom))
                chatUserManager.cleanupListeners()
            }
            chatUserManager.listenForChatRequestDeletion()
        }
    }

    func loadingSpinner() -> some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 6)
                .opacity(0.3)
                .foregroundColor(.gray)

            Circle()
                .trim(from: 0, to: 0.25)
                .stroke(style: StrokeStyle(lineWidth: 6, lineCap: .round))
                .foregroundColor(Color.NAMITealBlue)
                .rotationEffect(.degrees(rotation))
                .animation(.linear(duration: 1).repeatForever(autoreverses: false), value: rotation)
                .onAppear {
                    self.rotation = 360
                }
        }
    }

    func cancelChatButton() -> some View {
        Button {
            if chatUserManager.isCurrentChatRequestRemoved {
                chatUserRouter.navigateToRoot()
            } else {
                showAlert = true
            }
        } label: {
            Text("Cancel Chat")
                .font(.callout)
                .frame(maxWidth: .infinity)
                .padding(.vertical)
                .background(colorScheme == .dark ? Color.NAMITealBlue : Color.NAMITealBlue.opacity(0.05))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.black, lineWidth: 1)
                )
        }
        .padding()
        .padding(.horizontal)
    }
}



#Preview {
    ChatWaitingView()
        .environment(ChatUserRouter())
}
