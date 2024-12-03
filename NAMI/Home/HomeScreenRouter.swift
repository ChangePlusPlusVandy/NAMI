//
//  Router.swift
//  NAMI
//
//  Created by Zachary Tao on 11/10/24.
//

import SwiftUI

@Observable
final class HomeScreenRouter {

    public enum Destination: Hashable {
        case userProfileView
        case userProfileEditView
        case adminEventCreationView
    }

    var navPath = NavigationPath()

    func navigate(to destination: Destination) {
        navPath.append(destination)
    }

    func navigateBack() {
        if navPath.count > 0 {
            navPath.removeLast()
        }
    }

    func navigateToRoot() {
        navPath.removeLast(navPath.count)
    }
}
