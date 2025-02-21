//
//  MemberRouter.swift
//  NAMI
//
//  Created by Zachary Tao on 1/22/25.
//

import SwiftUI

@MainActor
@Observable
final class MemberRouter {

    public enum Destination: Hashable {
        case adminPromotionView
        case volunteerPromotionView

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
