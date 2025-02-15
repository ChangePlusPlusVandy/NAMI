//
//  ChatWaitingView.swift
//  NAMI
//
//  Created by stevenysy on 2/10/25.
//

import SwiftUI

struct ChatWaitingView: View {
    @State private var rotation: Double = 0
    
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
                    .frame(width: 50, height: 50)
            }
        }
    }
    
    func loadingSpinner() -> some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 4)
                .opacity(0.3)
                .foregroundColor(.gray)
            
            Circle()
                .trim(from: 0, to: 0.25)
                .stroke(style: StrokeStyle(lineWidth: 4, lineCap: .round))
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
