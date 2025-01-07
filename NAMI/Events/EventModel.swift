//
//  EventsModel.swift
//  NAMI
//
//  Created by Zachary Tao on 11/10/24.
//

import SwiftUI
import FirebaseFirestore

struct Event: Identifiable, Equatable, Hashable, Codable {
    @DocumentID var id: String?
    var title: String
    var startTime: Date
    var endTime: Date
    var repeatType: RepeatType
    var endRepeat: Bool
    var endRepeatDate: Date
    var about: String
    var leaderName: String
    var leaderPhoneNumber: String

    var meetingMode: MeetingMode
    var eventCategory: EventCategory
    var eventSeries: EventSeries?

    var registeredUsersIds: [String]
}

extension Event {
    static var dummyEvent = Event(title: "Dummy",
                                  startTime: Date(),
                                  endTime: Date(),
                                  repeatType: .never,
                                  endRepeat: false,
                                  endRepeatDate: Date(),
                                  about: "This is what the event is about",
                                  leaderName: "Dana",
                                  leaderPhoneNumber: "123-456-7890",
                                  meetingMode: .virtual(link: "www.zoom.com"),
                                  eventCategory: .familyEducation,
                                  eventSeries: EventSeries(name: "NAMI Family to Family"),
                                  registeredUsersIds: [])
}

enum RepeatType: String, CaseIterable, Identifiable, Codable {
    case never = "Never"
    case daily = "Every Day"
    case weekly = "Every Week"
    case biweekly = "Every 2 Weeks"
    case monthly = "Every Month"
    case yearly = "Every Yeaer"
    case custom = "Custom"

    var id: String {self.rawValue}
}

enum MeetingMode: Equatable, Hashable, Codable {

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

    var iconName: String {
        switch self {
        case .inPerson:
            return "person.3"
        case .virtual:
            return "laptopcomputer.and.iphone"
        }
    }

    func updateLocationOrLink(with newValue: String) -> Self {
        switch self {
        case .inPerson:
            return .inPerson(location: newValue)
        case .virtual:
            return .virtual(link: newValue)
        }
    }
}

enum EventCategory: String, CaseIterable, Identifiable, Codable {
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

struct EventSeries: Identifiable, Hashable, Codable {
    var id = UUID()
    var name: String
}
