//
//  EventCardView.swift
//  NAMI
//
//  Created by Zachary Tao on 11/11/24.
//

import SwiftUI

struct EventCardView: View {
    var event: Event
    // TODO: Implement Event card view from the event object
    var body: some View {
        VStack{
            Text("This is an event")
        }
    }
}

#Preview {
    EventCardView(event: Event.dummyEvent)
}
