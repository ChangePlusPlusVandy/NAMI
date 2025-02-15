//
//  ChatWaitingView.swift
//  NAMI
//
//  Created by stevenysy on 2/10/25.
//

import SwiftUI

struct ChatWaitingView: View {
    @State private var rotation: Double = 0
    @State private var showingAlert = false
    
    private var helpMessage = "If you are experiencing a mental health crisis, please call or text 988, available 24/7/365"
    
    var body: some View {
        VStack {
            VStack(spacing: 0) {
                Image("NAMILogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 125)
                
                Text("HelpLine")
                    .font(.system(size: 20))
            }
            
            VStack {
                loadingSpinner()
                    .frame(width: 40, height: 40)
                    .padding(.top, 50)
                
                Text("Connecting...")
                    .padding(.top, 10)
            }
            .padding(.bottom, 50)
            
            VStack {
                Text(helpMessage)
                    .frame(maxWidth: 300)
                    .fontWeight(.light)
                    .multilineTextAlignment(.center)
                
                cancelChatButton()
            }
            .padding(.top, 100)
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
                .foregroundColor(.cyan)
                .rotationEffect(.degrees(rotation))
                .animation(.linear(duration: 1).repeatForever(autoreverses: false), value: rotation)
                .onAppear {
                    self.rotation = 360
                }
        }
    }
    
    func cancelChatButton() -> some View {
        var alertTitle = "Are you sure you want to cancel your chat request?"
        var alertMessage = "You're up next soon"
        
        return Button(action: {
            showingAlert = true
                }) {
                    Text("Cancel Chat")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.black, lineWidth: 1)
                        )
                }
                .alert(alertTitle, isPresented: $showingAlert) {
                    Button("Cancel", role: .cancel) { }
                    Button("Exit", role: .destructive, action: {
                        print("exited chat")  // TODO: implement exit navigation
                    })
                } message: {
                    Text(alertMessage)
                }
                .padding(.horizontal, 30)
                .padding(.top, 25)
    }
}



#Preview {
    ChatWaitingView()
}
