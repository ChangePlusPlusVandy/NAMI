//
//  MemberInfoSheet.swift
//  NAMI
//
//  Created by Zachary Tao on 1/21/25.
//

import SwiftUI

struct MemberInfoSheet: View {
    @Binding var user: NamiUser?
    @Environment(\.dismiss) var dismiss
    @State var showPositionRemovalAlert = false
    var body: some View {
        VStack (alignment: .leading) {
            profileRow(label: "First Name:", value: user?.firstName)
            Spacer()
            profileRow(label: "Last Name:", value: user?.lastName)
            Spacer()
            profileRow(label: "Email:", value: user?.email)
            Spacer()
            profileRow(label: "Phone:", value: user?.phoneNumber)
            Spacer()
            profileRow(label: "Zip Code:", value: user?.zipCode)
            Spacer()
            profileRow(label: "User Type:", value: user?.userType.description)

            Spacer()
            if user?.userType == .admin || user?.userType == .volunteer {
                removePositionButton
                    .padding(.top, 20)
            }
        }
        .padding(.vertical, 60)
    }

    var removePositionButton: some View {
        Button(role: .destructive) {
            showPositionRemovalAlert.toggle()
        } label: {
            if user?.userType == .admin {
                Text("Remove Admin Position")
                    .frame(width: 300, height: 50)
                    .foregroundStyle(.white)
                    .background(.red)
                    .cornerRadius(10)
            } else if user?.userType == .volunteer {
                Text("Remove Volunteer Position")
                    .frame(width: 300, height: 50)
                    .foregroundStyle(.white)
                    .background(.red)
                    .cornerRadius(10)
            }
        }
        .confirmationDialog(
            "Are you sure you want to remove this person's position? This action is permanent and cannot be undone. The user will become a regular NAMI member.",
            isPresented: $showPositionRemovalAlert, titleVisibility: .visible
        ) {
            Button("Delete", role: .destructive) {
                UserManager.shared.updateSpecificNamiUserType(userIDtoBeUpdated: user?.id ?? "", newUserType: .member)
                dismiss()
            }
            Button("Cancel", role: .cancel) { showPositionRemovalAlert.toggle() }
        }
    }

    func profileRow(label: String, value: String?) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(label)
                .fontWeight(.semibold)
            Text(value ?? "error")
                .foregroundColor(.secondary)
        }
    }
}

//#Preview {
//    MemberInfoSheet(user: NamiUser.errorUser)
//}
