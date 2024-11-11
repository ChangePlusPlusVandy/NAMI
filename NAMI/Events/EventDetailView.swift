//
//  EventDetailView.swift
//  NAMI
//
//  Created by Zachary Tao on 11/10/24.
//

import SwiftUI

struct EventDetailView: View {
    var event: Event
    // TODO: Implement Event detail view from the event object
    var body: some View {
        Text("This is event detail view")
    }
}

#Preview {
    EventDetailView(event: Event(title: "Dummy title", location: "2301 Vanderbilt Pl", date: "2020/12/12", about: "a very long about", meetingMode: .virtual(link: "www.zoom.com")))
}
