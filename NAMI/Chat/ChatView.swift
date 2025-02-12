//
//  ChatView.swift
//  NAMI
//
//  Created by Zachary Tao on 11/10/24.
//

import SwiftUI

struct ChatView: View {
    @State private var showChatUnavailable = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 40) {

                    VStack(alignment: .leading, spacing: 13) {
                        Text("In Need Of Help Or Support?")
                            .font(.headline)
                            .padding(.top, 35)
                        Text("You are not alone! If you are struggling with your mental health, the NAMI HelpLine is here for you. Connect with a NAMI HelpLine volunteer today.")
                            .font(.body)
                            .foregroundStyle(.secondary)
                    }

                    VStack(alignment: .leading, spacing: 13) {
                        Text("Hours Available")
                            .font(.headline)
                        Text("Monday Through Friday, 10 A.M. – 10 P.M. ET.")
                            .font(.body)
                            .foregroundStyle(.secondary)
                    }

                    VStack(alignment: .leading, spacing: 13) {
                        Text("Are you experiencing a mental health crisis?")
                            .font(.headline)
                        Text("Please call or text 988, available 24/7/365")
                            .font(.body)
                            .foregroundStyle(.secondary)
                    }

                    Button {
                        withAnimation(.snappy) {
                            if !withinOperatingHours() {
                                showChatUnavailable = true
                            }
                        }
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
                    .sensoryFeedback(.impact(weight:.heavy), trigger: showChatUnavailable)

                }
                .padding(.horizontal, 30)
            }
            .navigationTitle("HelpLine")
            .overlay {
                if showChatUnavailable {
                    ChatUnavailableView(isPresented: $showChatUnavailable)
                }
            }
        }
    }
}

func withinOperatingHours() -> Bool {
    let now = Date()

    guard let cstTimeZone = TimeZone(identifier: "America/Chicago") else {
        return false
    }

    // Get the current hour in CST
    let calendar = Calendar.current
    let components = calendar.dateComponents(in: cstTimeZone, from: now)

    if let hour = components.hour {
        return hour >= 10 && hour < 22
    }

    return false
}

#Preview {
    ChatView()
}
