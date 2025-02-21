//
//  ChatRouter.swift
//  NAMI
//
//  Created by Zachary Tao on 2/18/25.
//

import SwiftUI

@MainActor
@Observable
final class ChatUserRouter {

    public enum Destination: Hashable {
        case chatWaitingView
        case chatRequestView
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

@MainActor
@Observable
final class ChatAdminRouter {

    public enum Destination: Hashable {
        case chatRoomView(chatRoom: ChatRoom)
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
