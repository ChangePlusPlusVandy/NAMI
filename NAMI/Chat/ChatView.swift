//
//  ChatView.swift
//  NAMI
//
//  Created by Zachary Tao on 2/18/25.
//

import SwiftUI

struct ChatView: View {
    @Environment(TabsControl.self) var tabVisibilityControls
    var body: some View {
        if UserManager.shared.isVolunteerOrAdmin() {
            ChatAdminHomeView()
                .environment(tabVisibilityControls)
        } else {
            ChatStartingView()
                .environment(tabVisibilityControls)
        }
    }
}

