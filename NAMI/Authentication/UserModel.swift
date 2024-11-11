//
//  UserModel.swift
//  NAMI
//
//  Created by Zachary Tao on 11/10/24.
//

import Foundation
import FirebaseFirestore

enum UserType : Codable {
    case member
    case admin
    // we will add volunteer user later
}

struct NamiUser: Codable, Identifiable {
    @DocumentID var id: String?
    var userType: UserType
    var isAdmin: Bool

    var name: String
    var email: String
    var phoneNumber: String

    static var errorUser = NamiUser(userType: .member, isAdmin: false, name: "Error", email: "Error", phoneNumber: "Error")
}
