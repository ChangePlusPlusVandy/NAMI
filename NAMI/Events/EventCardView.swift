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
        VStack(alignment: .leading) {
            eventCategoryCapsuleView(eventCategory: event.eventCategory)

            Spacer()
            Text(event.title)
                .font(.title3.bold())

            Spacer()
            Text(event.startTime.formatted(date: .abbreviated, time: .omitted))
                .foregroundStyle(.secondary)
                .font(.caption)

            Text(formatEventDurationWithTimeZone(startTime: event.startTime, endTime: event.endTime))
                .foregroundStyle(.secondary)
                .font(.caption)

            Spacer()
            HStack {
                meetingModeCapsuleView(meetingMode: event.meetingMode)

                if let series = event.eventSeries {
                    eventSeriesCapsuleView(eventSeries: series, eventCategory: event.eventCategory)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 250)
        //.cornerRadius(20)
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.secondary, lineWidth: 1))
        .contentShape(Rectangle())

    }

    /// Converts the startTime and endTime to the user's current time zone, then formats the adjusted times
    /// to a string with the format "startTime - endTime userTimeZone".
    /// - Parameters:
    ///   - startTime: The start time of an event
    ///   - endTime: The end time of an event
    /// - Returns: A formatted string representing the duration of the event in the user's current time zone
    private func formatEventDurationWithTimeZone(startTime: Date, endTime: Date) -> String {
        // This assumes NAMI posts events in central time, may need to change later
        let initTimeZone = TimeZone(identifier: "America/Chicago")!
        let userTimeZone = TimeZone.current

        let adjustedStartTime = startTime.convertToTimeZone(initTimeZone: initTimeZone, targetTimeZone: userTimeZone)
        let adjustedEndTime = endTime.convertToTimeZone(initTimeZone: initTimeZone, targetTimeZone: userTimeZone)

        return "\(adjustedStartTime.formatted(date: .omitted, time: .shortened)) - \(adjustedEndTime.formatted(date: .omitted, time: .shortened)) \(userTimeZone.abbreviation()!)"
    }

    func eventCategoryCapsuleView(eventCategory: EventCategory) -> some View {
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

    func eventSeriesCapsuleView(eventSeries: EventSeries, eventCategory: EventCategory) -> some View {
        Text(eventSeries.name)
            .font(.caption)
            .padding(.horizontal, 5)
            .padding(.vertical, 2)
            .foregroundColor(
                eventCategory == EventCategory.peerSupport ? Color.black : Color.white
            )
            .background(eventCategory.color)
            .clipShape(RoundedRectangle(cornerRadius: 5))
    }


    func meetingModeCapsuleView(meetingMode: MeetingMode) -> some View {
        HStack(spacing: 3) {
            Image(systemName: meetingMode.iconName)
                .controlSize(.mini)
            Text(meetingMode.displayName)
        }
        .font(.callout)
        .padding(.horizontal, 5)
        .padding(.vertical, 2)
        .background(Color(UIColor.systemGray5))
        .clipShape(RoundedRectangle(cornerRadius: 5))
        .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.secondary, lineWidth: 1))
    }
}

extension Date {
    func convertToTimeZone(initTimeZone: TimeZone, targetTimeZone: TimeZone) -> Date {
        let delta = TimeInterval(targetTimeZone.secondsFromGMT(for: self) - initTimeZone.secondsFromGMT(for: self))
        return addingTimeInterval(delta)
    }
}

#Preview {
    EventCardView(event: Event.dummyEvent)
        .padding(.horizontal, 10)
}
