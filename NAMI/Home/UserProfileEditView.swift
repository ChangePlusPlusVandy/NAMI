//
//  UserProfileEditView.swift
//  NAMI
//
//  Created by Zachary Tao on 11/17/24.
//

import SwiftUI

struct UserProfileEditView: View {
    @Environment(HomeScreenRouter.self) var homeScreenRouter
    var body: some View {
        Text("This view is the user profile edit view!")
    }
}

#Preview {
    UserProfileEditView()
        .environment(HomeScreenRouter())
}
