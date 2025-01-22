//
//  PromotionView.swift
//  NAMI
//
//  Created by Zachary Tao on 1/22/25.
//

import SwiftUI
import FirebaseFirestore

struct PromotionView: View {
    @State var searchEmail = ""
    @State var userNotFouneError = false
    @State var searchResult: NamiUser?
    @State var showConfirmation = false

    @FocusState private var isKeyboardFocused: Bool

    var promotionType = PromotionType.admin

    @Environment(TabsControl.self) var tabVisibilityControls
    @Environment(MemberRouter.self) var memberRouter

    var body: some View {
        ScrollView(showsIndicators: false) {
            searchBar

            if userNotFouneError {
                Text("No user found with this email.")
                    .foregroundColor(.red)
            }

            if let user = searchResult {
                if user.userType == promotionType.userType(){
                    Text("This user is already the \(promotionType.rawValue)")
                } else {
                    VStack(alignment: .leading, spacing: 25) {
                        profileRow(label: "First Name:", value: user.firstName)
                        profileRow(label: "Last Name:", value: user.lastName)
                        profileRow(label: "Email:", value: user.email)
                        profileRow(label: "Phone:", value: user.phoneNumber)
                        profileRow(label: "Zip Code:", value: user.zipCode)
                        profileRow(label: "User Type:", value: user.userType.description)
                        confirmationButton
                            .padding(.top, 20)
                    }
                    .padding(.horizontal, 30)
                    .padding(.top, 20)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                }
            }
        }
        .padding(.horizontal, 20)
        .ignoresSafeArea(.keyboard)
        .navigationTitle("Add \(promotionType.rawValue)")
        .confirmationDialog(
            "Are you sure what to update this user's user type from \(searchResult?.userType.description ?? "Unknown") to \(promotionType.rawValue)?",
            isPresented: $showConfirmation,
            titleVisibility: .visible
        ) {
            Button("Add User as \(promotionType.rawValue)") {
                UserManager.shared.updateSpecificNamiUserType(userIDtoBeUpdated: searchResult?.id ?? "", newUserType: promotionType.userType())
                memberRouter.navigateBack()
            }
        }
    }

    var confirmationButton: some View {
        Button {
            showConfirmation = true
        } label: {
            Text("Add this user as a new \(promotionType.rawValue)")
                .fontWeight(.semibold)
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity)
                .background(Color.NAMITealBlue)
                .foregroundColor(.white)
                .cornerRadius(25)
        }
    }

    var searchBar: some View {
        HStack {
            TextField("Enter email address", text: $searchEmail)
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 10.0).strokeBorder(.gray, style: StrokeStyle(lineWidth: 1.0)))
                .focused($isKeyboardFocused)
                .keyboardType(.emailAddress)

            Button {
                userNotFouneError = false
                searchResult = nil
                fetchSearchUser(searchEmail: searchEmail)
                isKeyboardFocused = false
            } label: {
                Text("Search")
                    .fontWeight(.semibold)
                    .padding(.horizontal, 5)
                    .padding(.vertical)
                    .background(searchEmail.isEmpty ? Color.NAMIDarkBlue.opacity(0.5) : Color.NAMIDarkBlue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }.disabled(searchEmail.isEmpty)
        }
    }

    private func fetchSearchUser(searchEmail: String) {
        let db = Firestore.firestore()

        let query = db.collection("users")
            .whereField("email", isEqualTo: searchEmail)
            .limit(to: 1)

        Task {
            do {
                let querySnapshot = try await query.getDocuments()
                let documents = querySnapshot.documents
                guard let document = documents.first else { userNotFouneError = true; return }
                let result = try document.data(as: NamiUser.self)
                searchResult = result
            } catch {
                userNotFouneError = true
                print("error fetching user: \(error.localizedDescription)")
            }
        }

    }

    enum PromotionType: String {
        case admin = "Admin"
        case volunteer = "Volunteer"

        func userType() -> UserType {
            if self == .admin {
                return .admin
            } else {
                return .volunteer
            }
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

#Preview {
    NavigationStack {
        PromotionView()
            .environment(TabsControl())
            .environment(MemberRouter())
    }
}
