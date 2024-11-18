//
//  EventsViewRouter.swift
//  NAMI
//
//  Created by Zachary Tao on 11/17/24.
//

import SwiftUI

@Observable
final class EventsViewRouter {

    public enum Destination: Hashable {
        case eventDetailView(event: Event)
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
