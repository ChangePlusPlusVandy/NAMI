//
//  UserModel.swift
//  NAMI
//
//  Created by Zachary Tao on 11/10/24.
//

import Foundation
import FirebaseFirestore

enum UserType : Codable {
    case superAdmin
    case admin
    case volunteer
    case member

    var description: String {
        switch self {
        case .superAdmin:
            return "Super Admin"
        case .admin:
            return "Admin"
        case .volunteer:
            return "Volunteer"
        case .member:
            return "Member"
        }
    }
}

struct NamiUser: Codable, Identifiable {
    @DocumentID var id: String?
    var userType: UserType

    var firstName: String
    var lastName: String
    var email: String
    var phoneNumber: String
    var zipCode: String

    static var errorUser = NamiUser(userType: .member, firstName: "Error", lastName: "Error", email: "error.com", phoneNumber: "error", zipCode: "123")
}
