//
//  EventDetailView.swift
//  NAMI
//
//  Created by Zachary Tao on 11/10/24.
//

import SwiftUI

struct EventDetailView: View {
    @Environment(EventsViewRouter.self) var eventsViewRouter
    var event: Event
    // TODO: Implement Event detail view from the event object
    var body: some View {
        Text("This is event detail view")
    }
}

#Preview {
    EventDetailView(event: Event.dummyEvent)
        .environment(EventsViewRouter())
}
