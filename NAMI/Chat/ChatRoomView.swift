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
    @Binding var isPresented: Bool

    var body: some View {
        ZStack {
            Color.white.opacity(1.0)
                .edgesIgnoringSafeArea(.all)
            VStack {
                // Header with chat name
                HStack {
                    Button(action: {
                        withAnimation(.snappy) {isPresented = false}
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
                        withAnimation(.snappy) {isPresented = false}
                    }) {
                        Image(systemName: "xmark")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 15)
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
                                        .background(Color.NAMITealBlue)
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                        .frame(maxWidth: 250, alignment: .trailing)
                                }
                            } else {
                                HStack(alignment: .top, spacing: 10) {
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
                HStack {
                    TextField("Type a message...", text: $message)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(20)
                        .frame(minHeight: 44)
                    Button(action: {
                    }) {
                        Image(systemName: "arrow.up.circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(Color.NAMIDarkBlue)
                    }
                }
                .padding()
            }
            .navigationTitle("")
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    ChatRoomView(isPresented: .constant(true))

}
