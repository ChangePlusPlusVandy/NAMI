//
//  ChatRouter.swift
//  NAMI
//
//  Created by Zachary Tao on 2/18/25.
//

import SwiftUI

@Observable
final class ChatRouter {

    public enum Destination: Hashable {
        case chatWaitingView
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
