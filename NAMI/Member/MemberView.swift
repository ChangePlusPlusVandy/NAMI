//
//  MemberView.swift
//  NAMI
//
//  Created by Zachary Tao on 1/21/25.
//

import SwiftUI
import FirebaseFirestore

struct MemberView: View {
    @FirestoreQuery(collectionPath: "users",
                    predicates: [.whereField("userType", isEqualTo: UserType.superAdmin.rawValue)],
                    animation: .default) var superAdmins: [NamiUser]

    @FirestoreQuery(collectionPath: "users",
                    predicates: [.whereField("userType", isEqualTo: UserType.admin.rawValue)],
                    animation: .default) var admins: [NamiUser]

    @FirestoreQuery(collectionPath: "users",
                    predicates: [.whereField("userType", isEqualTo: UserType.volunteer.rawValue)],
                    animation: .default) var volunteers: [NamiUser]

    @State var showMemberInfoSheet = false
    @State var tappedUser: NamiUser?


    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Super Admin")) {
                    ForEach(superAdmins) { user in
                        MemberColumnView(user: user)
                    }
                }
                
                Section(header: Text("Admins")) {
                    ForEach(admins) { user in
                        memberCellButton(user: user, tappedUser: $tappedUser, showMemberInfoSheet: $showMemberInfoSheet)
                    }
                }
                
                Section(header: Text("Volunteers")) {
                    ForEach(volunteers) { user in
                        memberCellButton(user: user, tappedUser: $tappedUser, showMemberInfoSheet: $showMemberInfoSheet)
                    }
                }
            }
            .navigationTitle("NAMI Members")
            .sheet(isPresented: $showMemberInfoSheet){ MemberInfoSheet(user: $tappedUser)}
        }
    }

    struct memberCellButton: View {
        var user: NamiUser
        @State var showPositionRemovalAlert = false
        @Binding var tappedUser: NamiUser?
        @Binding var showMemberInfoSheet: Bool
        var body: some View {
            Button {
                tappedUser = user
                showMemberInfoSheet = true
            } label: {
                MemberColumnView(user: user)
            }
            .contextMenu {
                Button("", systemImage: "trash") { showPositionRemovalAlert = true }
                    .tint(.red)
            }
            .swipeActions{
                Button("", systemImage: "trash") { showPositionRemovalAlert = true }
                    .tint(.red)
            }
            .confirmationDialog(
                "Are you sure you want to remove this person's position? This action is permanent and cannot be undone. The user will become a regular NAMI member.",
                isPresented: $showPositionRemovalAlert, titleVisibility: .visible
            ) {
                Button("Delete", role: .destructive) {
                    UserManager.shared.updateSpecificNamiUserType(userIDtoBeUpdated: user.id ?? "", newUserType: .member)
                }
                Button("Cancel", role: .cancel) { showPositionRemovalAlert.toggle() }
            }
        }
    }
}

#Preview {
    NavigationStack {
        MemberView()
    }
}
