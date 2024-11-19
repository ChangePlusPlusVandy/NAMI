//
//  ChatView.swift
//  NAMI
//
//  Created by Zachary Tao on 11/10/24.
//

import SwiftUI

struct ChatView: View {
    var body: some View {
        NavigationStack{
            VStack{
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("NAMI Helpline")
                        .franklinGothic(.regular, 28)
                }
            }
        }
    }
}

#Preview {
    ChatView()
}
