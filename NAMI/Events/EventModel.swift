//
//  EventsModel.swift
//  NAMI
//
//  Created by Zachary Tao on 11/10/24.
//

import SwiftUI

struct Event: Identifiable, Equatable, Hashable {
    let id = UUID()
    let title: String
    let startTime: Date
    let endTime: Date
    let about: String

    let meetingMode: MeetingMode
    let eventCategory: EventCategory
    var eventSeries: EventSeries?

    static var dummyEvent = Event(title: "This is an event by NAMI", startTime: Date(), endTime: Date(), about: "This is what the event is about", meetingMode: .virtual(link: "www.zoom.com"), eventCategory: .familyEducation, eventSeries: EventSeries(name: "NAMI Family to Family"))
}

enum MeetingMode: Equatable, Hashable {
    case inPerson(location: String)
    case virtual(link: String)

    var displayName: String {
        switch self {
        case .inPerson:
            return "In Person"
        case .virtual:
            return "Virtual"
        }
    }
}

enum EventCategory: String, CaseIterable, Identifiable {
    case familySupport = "Family/Caregiver Support"
    case familyEducation = "Family/Caregiver Education"
    case peerSupport = "Peer Support"
    case peerEducation = "Peer Education"
    case specialEvents = "Special Events"

    var id: String { self.rawValue }

    var color: Color {
        switch self {
        case .familySupport:
            return Color.FamilyCaregiverSupport
        case .familyEducation:
            return Color.FamilyCaregiverEducation
        case .peerSupport:
            return Color.PeerSupport
        case .peerEducation:
            return Color.PeerEducation
        case .specialEvents:
            return Color.SpecialEvents
        }
    }
}

struct EventSeries: Identifiable, Hashable {
    let id = UUID()
    let name: String
}
