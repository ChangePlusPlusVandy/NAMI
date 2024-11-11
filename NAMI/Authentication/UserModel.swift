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


    var firstName: String
    var lastName: String
    var email: String
    var phoneNumber: String
    var zipCode: String
    var profilePictureULR: String?

    static var errorUser = NamiUser(id: "", userType: .member, firstName: "Error", lastName: "Error", email: "error.com", phoneNumber: "error", zipCode: "123")
}
