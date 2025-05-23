//
//  EventCardView.swift
//  NAMI
//
//  Created by Zachary Tao on 11/11/24.
//

import SwiftUI

struct EventCardView: View {

    var event: Event
    var showRegistered: Bool

    var body: some View {
        VStack(alignment: .leading) {
            EventCategoryCapsule(eventCategory: event.eventCategory)
            Spacer()
            Text(event.title)
                .font(.title3.bold())
                .lineLimit(3)
            Spacer()
            Text(event.startTime.formatted(date: .abbreviated, time: .omitted))
                .foregroundStyle(.secondary)
                .font(.caption)
            Text(formatEventDurationWithTimeZone(startTime: event.startTime, endTime: event.endTime))
                .foregroundStyle(.secondary)
                .font(.caption)
            Spacer()
            HStack {
                MeetingModeCapsule(meetingMode: event.meetingMode)
                Spacer()
                if UserManager.shared.isAdmin() {
                    Text("^[\(event.registeredUsersIds.count) person](inflected: true) registered")
                        .foregroundStyle(.secondary)
                        .font(.caption)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 200)
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.secondary, lineWidth: 1))
        .overlay {
            if showRegistered,
               let registeredEvents = UserManager.shared.currentUser?.registeredEventsIds,
               registeredEvents.contains(event.id ?? "")
            {
                Image(systemName: "checkmark.seal.fill")
                    .foregroundStyle(.yellow)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                    .padding()
            }
        }
        .contentShape(Rectangle())
    }
}

struct MeetingModeCapsule: View{
    let meetingMode: MeetingMode
    var body: some View {
        HStack(spacing: 3) {
            Image(systemName: meetingMode.iconName)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 20)
            Text(meetingMode.displayName)
        }
        .font(.caption)
        .padding(.horizontal, 5)
        .padding(.vertical, 2)
        .background(Color(UIColor.systemGray5))
        .clipShape(RoundedRectangle(cornerRadius: 5))
        .overlay(RoundedRectangle(cornerRadius: 5).strokeBorder(Color.secondary, lineWidth: 1))
    }
}

struct EventCategoryCapsule: View {
    let eventCategory: EventCategory
    var body: some View {
        Text(eventCategory.rawValue)
            .font(.caption)
            .foregroundColor(
                eventCategory == EventCategory.peerSupport ? Color.black : Color.white
            )
            .padding(.horizontal, 5)
            .padding(.vertical, 2)
            .background(eventCategory.color)
            .clipShape(RoundedRectangle(cornerRadius: 5))
    }
}

extension Date {
    func convertToTimeZone(initTimeZone: TimeZone, targetTimeZone: TimeZone) -> Date {
        let delta = TimeInterval(targetTimeZone.secondsFromGMT(for: self) - initTimeZone.secondsFromGMT(for: self))
        return addingTimeInterval(delta)
    }
}

#Preview {
    EventCardView(event: Event.dummyEvent, showRegistered: false)
        .padding(.horizontal, 10)
}
