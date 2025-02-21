//
//  EventsViewRouter.swift
//  NAMI
//
//  Created by Zachary Tao on 11/17/24.
//

import SwiftUI

@MainActor
@Observable
final class EventsViewRouter {
    
    public enum Destination: Hashable {
        case eventDetailView(event: Event)
        case eventCreationView(event: Event)
        case eventUpdateView(event: Event)
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
