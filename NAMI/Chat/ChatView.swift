//
//  ChatView.swift
//  NAMI
//
//  Created by Zachary Tao on 2/18/25.
//

import SwiftUI

struct ChatView: View {
    var body: some View {
        if UserManager.shared.isChatAdmin() {
            ChatAdminHomeView()
        } else {
            ChatStartingView()
        }
    }
}

