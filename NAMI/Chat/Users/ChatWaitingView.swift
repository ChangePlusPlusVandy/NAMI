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

            loadingSpinner()
                .frame(width: 40)

            Text("Connecting...")
                .fontWeight(.light)
                .padding(.top, 5)

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
                ChatManager.shared.deleteCurrentChatRoomRequest()
                chatUserRouter.navigateToRoot()
            }
        } message: {
            Text("You're up next soon")
        }
        .navigationBarBackButtonHidden(true)
        .ignoresSafeArea(.all)
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
            showAlert = true
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
