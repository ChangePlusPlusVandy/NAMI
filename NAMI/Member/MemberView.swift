//
//  MemberView.swift
//  NAMI
//
//  Created by Zachary Tao on 1/21/25.
//

import SwiftUI
import FirebaseFirestore

struct MemberView: View {
    @Environment(TabsControl.self) var tabVisibilityControls
    @State var memberRouter = MemberRouter()

    @FirestoreQuery(collectionPath: "users",
                    predicates: [.whereField("userType", isEqualTo: UserType.admin.rawValue)],
                    animation: .default) var admins: [NamiUser]

    @FirestoreQuery(collectionPath: "users",
                    predicates: [.whereField("userType", isEqualTo: UserType.volunteer.rawValue)],
                    animation: .default) var volunteers: [NamiUser]

    @State var showMemberInfoSheet = false
    @State var tappedUser: NamiUser?
    @State var searchText = ""

    var body: some View {
        NavigationStack(path: $memberRouter.navPath) {
            List {
                createSection(title: "Admins", users: admins)
                createSection(title: "Volunteers", users: volunteers)
            }
            .searchable(text: $searchText)
            .navigationTitle("NAMI Members")
            .sheet(isPresented: $showMemberInfoSheet){ MemberInfoSheet(user: $tappedUser)}
            .onChange(of: memberRouter.navPath) {
                if memberRouter.navPath.isEmpty {
                    tabVisibilityControls.makeVisible()
                }
            }
            .navigationDestination(for: MemberRouter.Destination.self) { destination in
                switch destination {
                case .adminPromotionView:
                    PromotionView(promotionType: .admin)
                        .environment(memberRouter)
                case .volunteerPromotionView:
                    PromotionView(promotionType: .volunteer)
                        .environment(memberRouter)
                }
            }
        }
    }

    private func createSection(title: String, users: [NamiUser]) -> some View {
        let filteredUsers = users.filter { searchText.isEmpty || $0.firstName.localizedCaseInsensitiveContains(searchText) ||
            $0.lastName.localizedCaseInsensitiveContains(searchText)
        }

        return Section(header: Text(title)) {
            if title == "Admins", searchText.isEmpty {
                Button{
                    tabVisibilityControls.makeHidden()
                    memberRouter.navigate(to: .adminPromotionView)
                } label: {
                    Text("Add new Admins")
                        .bold()
                        .padding(.vertical, 8)
                        .contentShape(Rectangle())
                }
            } else if title == "Volunteers", searchText.isEmpty {
                Button{
                    tabVisibilityControls.makeHidden()
                    memberRouter.navigate(to: .volunteerPromotionView)
                } label: {
                    Text("Add new Volunteers")
                        .bold()
                        .padding(.vertical, 8)
                        .contentShape(Rectangle())
                }
            }
            ForEach(filteredUsers) { user in
                memberCellButton(user: user, tappedUser: $tappedUser, showMemberInfoSheet: $showMemberInfoSheet)
            }
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
