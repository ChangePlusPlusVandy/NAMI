//
//  MemberColumnView.swift
//  NAMI
//
//  Created by Zachary Tao on 1/21/25.
//

import SwiftUI

struct MemberColumnView: View {
    var user: NamiUser
    var body: some View {
        HStack(spacing: 4) {
            Text(user.firstName)
            Text(user.lastName)
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    List {
        Section(header: Text("Header")) {
            MemberColumnView(user: .errorUser)
            MemberColumnView(user: .errorUser)
            MemberColumnView(user: .errorUser)
        }
    }
}
