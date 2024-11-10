//
//  Router.swift
//  NAMI
//
//  Created by Zachary Tao on 11/10/24.
//

import SwiftUI

@Observable
final class Router {

    public enum Destination: Hashable {
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
