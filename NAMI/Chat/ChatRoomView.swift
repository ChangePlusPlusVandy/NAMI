//
//  ChatRoomView.swift
//  NAMI
//
//  Created by Sophie Zhuang on 1/12/25.
//

import SwiftUI
struct ChatRoomView: View {
    @State private var message: String = ""
    @State private var messages: [String] = [
        "s excepturi sint occaecati cupiditate non provident, similique",
        "Nam libero tempore, cum soluta",
        "officia deserunt",
        "assumenda est, omnis dolor repellendus",
        "Nam libero tempore, cum soluta"
    ]
    var body: some View {
        VStack {
            // Header with chat name
            HStack {
                Button(action: {
                }) {
                    Image(systemName: "arrow.left")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.black)
                }
                Text("Anonymous12")
                    .font(.headline)
                    .foregroundColor(.black)
                Spacer()
                Button(action: {
      
                }) {
                    Image(systemName: "ellipsis")
                        .resizable()
                        .frame(width: 20, height: 5)
                        .foregroundColor(.black)
                }
            }
            .padding()
            // Chat messages list
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(messages, id: \..self) { message in
                        if message == "assumenda est, omnis dolor repellendus" {
                            HStack {
                                Spacer()
                                Text(message)
                                    .padding()
                                    .background(Color.purple)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                    .frame(maxWidth: 250, alignment: .trailing)
                            }
                        } else {
                            HStack(alignment: .top, spacing: 10) {
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(.gray)
                                Text(message)
                                    .padding()
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(10)
                                    .frame(maxWidth: 250, alignment: .leading)
                                Spacer()
                            }
                        }
                    }
                }
                .padding()
            }
            // Input field and send button
            HStack {
                Button(action: {
                }) {
                    Image(systemName: "face.smiling")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .foregroundColor(.gray)
                }
                TextField("Type a message...", text: $message)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(20)
                    .frame(minHeight: 44)
                Button(action: {
                }) {
                    Image(systemName: "mic.fill")
                        .resizable()
                        .frame(width: 20, height: 25)
                        .foregroundColor(.gray)
                }
                Button(action: {
                }) {
                    Image(systemName: "arrow.up.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.blue)
                }
            }
            .padding()
        }
        .navigationTitle("")
        .navigationBarHidden(true)
    }
}
struct ChatRoomView_Previews: PreviewProvider {
    static var previews: some View {
        ChatRoomView()
    }
}
