//
//  EventCardView.swift
//  NAMI
//
//  Created by Zachary Tao on 11/11/24.
//

import SwiftUI

struct EventCardView: View {

    var event: Event
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            eventCategoryCapsuleView(eventCategory: event.eventCategory)
            
            Text(event.title)
                .font(.title3.bold())
                .lineLimit(3)
                .multilineTextAlignment(.leading)

            Text(event.startTime.formatted(date: .abbreviated, time: .omitted))
                .foregroundStyle(.secondary)
            
            Text("\(event.startTime.formatted(date: .omitted, time: .shortened)) - \(event.endTime.formatted(date: .omitted, time: .shortened))" )
                .foregroundStyle(.secondary)

            meetingModeCapsuleView(meetingMode: event.meetingMode)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 250)
        .cornerRadius(20)
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.secondary, lineWidth: 1))
        .contentShape(Rectangle())

    }
    
    
    func eventCategoryCapsuleView(eventCategory: EventCategory) -> some View {
        Group {
            Text(eventCategory.id)
                .font(.callout)
                .foregroundColor(
                    eventCategory == EventCategory.peerSupport ? Color.black : Color.white
                )
        }
        .padding(.horizontal, 5)
        .padding(.vertical, 2)
        .background(eventCategory.color)
        .clipShape(RoundedRectangle(cornerRadius: 5))
    }


    func meetingModeCapsuleView(meetingMode: MeetingMode) -> some View {
        Group {
            switch meetingMode {
            case .inPerson(_):
                HStack(spacing: 3) {
                    Image(systemName: "person.3")
                        .controlSize(.mini)
                    Text(meetingMode.displayName)
                        .font(.callout)
                }

            case .virtual(_):
                HStack(spacing: 3) {
                    Image(systemName: "laptopcomputer.and.iphone")
                        .controlSize(.mini)
                    Text(meetingMode.displayName)
                        .font(.callout)
                }
            }
        }
        .padding(.horizontal, 5)
        .padding(.vertical, 2)
        .background(Color(UIColor.systemGray5))
        .clipShape(RoundedRectangle(cornerRadius: 5))
        .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.secondary, lineWidth: 1))
    }
}

#Preview {
    EventCardView(event: Event.dummyEvent)
        .padding(.horizontal, 10)
}
