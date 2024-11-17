//
//  EventCardView.swift
//  NAMI
//
//  Created by Zachary Tao on 11/11/24.
//

import SwiftUI

struct EventCardView: View {
    var event: Event
    // TODO: Connect to event model
    var body: some View {
        RoundedRectangle(cornerRadius: 15)
            .stroke(Color.gray.opacity(0.8), lineWidth: 1)
            .frame(height: 200)
            .padding()
            .shadow(color: Color.black.opacity(0.2), radius: 4)
            .overlay(
                VStack(alignment: .leading) {
                    Text(event.title).font(.title)
                    Text(event.about)
                    
                    Text(event.date.formatted(date: .abbreviated, time: .omitted))
                        .padding(.top, 10)
                        .foregroundColor(Color(UIColor.darkGray))
                    
                    switch event.meetingMode {
                    case .inPerson:
                        Text(event.location)
                    case .virtual(let link):
                        Link("Event Link", destination: URL(string: link)!)
                    }
                }
            )
    }
}

#Preview {
    EventCardView(event: Event.dummyEvent)
}
