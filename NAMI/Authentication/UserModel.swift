//
//  UserModel.swift
//  NAMI
//
//  Created by Zachary Tao on 11/10/24.
//

import Foundation

enum UserType {
    case member
    case admin
    // we will add volunteer user later
    // case volunteer
}

struct Member {
    var name: String
    var email: String
    var phoneNumber: String
}
