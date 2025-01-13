//
//  ChatView.swift
//  NAMI
//
//  Created by Zachary Tao on 11/10/24.
//

import SwiftUI

struct ChatView: View {
    @State private var showChatUnavilable = false // State variable to control the pop-up

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 50) {

                    Text("You are not alone! If you are struggling with your mental health, the NAMI HelpLine is here for you. Connect with a NAMI HelpLine volunteer today.")
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .padding(.vertical, 20)

                    VStack(alignment: .leading, spacing: 10) {
                        Text("Available:")
                            .font(.headline)
                        Text("Monday Through Friday, 10 A.M. – 10 P.M. ET.")
                            .font(.body)
                            .foregroundStyle(.secondary)
                    }

                    contactInfo
                        .font(.body)

                    Button {
                        withAnimation(.snappy) {showChatUnavilable = true}
                    } label: {
                        Text("Start a Chat")
                            .padding(.horizontal, 10)
                            .padding()
                            .background(Color.NAMITealBlue)
                            .foregroundColor(.white)
                            .cornerRadius(25)
                    }
                    .padding(.top, 20)
                    .frame(maxWidth: .infinity, alignment: .center)
                }
                .padding(.horizontal, 25)
            }
            .navigationTitle("NAMI HelpLine")
            .overlay {
                if showChatUnavilable {
                    ChatUnavailableView(isPresented: $showChatUnavilable)
                }
            }
        }
    }

    var contactInfo: some View {
        Text("Call ")
        + Text("1-800-950-NAMI (6264)")
            .underline()
        + Text(", text \"HelpLine\" to ")
        + Text("62640")
            .underline()
        + Text(" or email us at ")
        + Text("helpline@nami.org")
            .underline()
    }
}

#Preview {
    ChatView()
}
