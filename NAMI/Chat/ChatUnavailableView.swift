//
//  ChatUnavailableView.swift
//  NAMI
//
//  Created by Sophie Zhuang on 1/2/25.
//

import SwiftUI
struct ChatUnavailableView: View {
    @Binding var isPresented: Bool
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    withAnimation(.snappy) { isPresented.toggle() }
                }

            VStack(spacing: 40) {
                VStack(alignment: .leading, spacing: 30) {
                    Text("Oh no, you’re reaching NAMI’s helpline outside of office hours")
                        .font(.title3)
                        .bold()

                    VStack(alignment: .leading, spacing: 10) {
                        Text("If you are experiencing a mental health crisis during this time, please call or text 988")
                            .font(.callout)

                        Text("The 988 Suicide & Crisis Lifeline is available 24/7")
                            .font(.callout)
                            .foregroundStyle(.secondary)
                    }
                }

                Button {
                    withAnimation (.snappy) { isPresented.toggle() }
                } label: {
                    Text("Dismiss")
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color.NAMIDarkBlue)
                        .foregroundColor(.white)
                        .cornerRadius(15)
                }
            }
            .padding(20)
            .background(colorScheme == .dark ? Color(.systemGray5) : Color.white)
            .cornerRadius(20)
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity, maxHeight: 400)
        }
    }
}

#Preview {
    ChatUnavailableView(isPresented: .constant(true))
}



