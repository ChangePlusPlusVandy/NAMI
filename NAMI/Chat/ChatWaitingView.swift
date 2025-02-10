//
//  ChatWaitingView.swift
//  NAMI
//
//  Created by stevenysy on 2/10/25.
//

import SwiftUI

struct ChatWaitingView: View {
    var body: some View {
        VStack {
            VStack(spacing: 0) {
                Image("NAMILogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300)
                
                Text("HelpLine")
                    .font(.headline)
            }
        }
    }
}

#Preview {
    ChatWaitingView()
}
