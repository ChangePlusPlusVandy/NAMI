//
//  AuthenticationRouter.swift
//  NAMI
//
//  Created by Zachary Tao on 11/11/24.
//

import SwiftUI

@Observable
final class AuthenticationRouter {

    public enum Destination: Hashable {
        case WelcomeView
        case LoginView
    }

    var navPath = NavigationPath()

    func navigate(to destination: Destination) {
        navPath.append(destination)
    }

    func navigateBack() {
        navPath.removeLast()
    }

    func navigateToRoot() {
        navPath.removeLast(navPath.count)
    }
}
