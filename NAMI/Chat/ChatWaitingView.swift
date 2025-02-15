//
//  ChatWaitingView.swift
//  NAMI
//
//  Created by stevenysy on 2/10/25.
//

import SwiftUI

struct ChatWaitingView: View {
    @State private var rotation: Double = 0
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
                    .padding(.top, 70)
                
                Text("Connecting...")
                    .padding(.top, 10)
            }
            
            VStack {
                Text(helpMessage)
                    .frame(maxWidth: 300)
                    .fontWeight(.light)
                    .multilineTextAlignment(.center)
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
}



#Preview {
    ChatWaitingView()
}
