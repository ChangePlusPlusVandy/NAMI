//
//  ChatRequestCell.swift
//  NAMI
//
//  Created by Zachary Tao on 2/19/25.
//

import SwiftUI

struct ChatRequestCell: View {
    var chatRequest: ChatRequest

    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    HStack {
                        Text(chatRequest.userName)
                            .font(.title3.bold())
                        Spacer()
                        Text(formatRelativeTime(from: chatRequest.requestTime))
                            .foregroundStyle(.secondary)
                    }
                    Text(chatRequest.requestReason)
                        .foregroundStyle(.secondary)
                }
            }
            Spacer(minLength: 10)
            HStack {
                Spacer()
                Button{

                } label: {
                    Text("Accept")
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color.NAMIDarkBlue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .buttonStyle(.borderless)

                Spacer(minLength: 20)
                Button{
                    ChatManager.shared.deleteChatRoomRequest(chatRequestId: chatRequest.id ?? "")
                } label: {
                    Text("Delete")
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .buttonStyle(.borderless)
                Spacer()
            }
        }
        .padding(.vertical, 10)
    }
}

#Preview {
    List {
        ChatRequestCell(chatRequest: ChatRequest(requestId: "1213", userName: "John John", userId: "123", requestTime: Date(), requestReason: "This is my request reason This is my request reason This is my request reason This is my request reason This is my request reason"))
        ChatRequestCell(chatRequest: ChatRequest(requestId: "1213", userName: "John John", userId: "123", requestTime: Date(), requestReason: "This is my request reason"))
        ChatRequestCell(chatRequest: ChatRequest(requestId: "1213", userName: "John John", userId: "123", requestTime: Date(), requestReason: "This is my request reason"))
    }
}
