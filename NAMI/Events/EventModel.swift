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
            return .blue
        case .familyEducation:
            return .green
        case .peerSupport:
            return .orange
        case .peerEducation:
            return .purple
        case .specialEvents:
            return .red
        }
    }
}

//struct EventCategory: Identifiable, Hashable {
//    let id = UUID()
//    let name: String
//    let color: Color
//    var series: [EventSeries] = []
//
//    static var familyCaregiverSupport = EventCategory(name: "Family/Caregiver Support", color: Color.FamilyCaregiverSupport, series: [])
//    static var familyCaregiverEducation = EventCategory(name: "Family/Caregiver Education", color: Color.FamilyCaregiverEducation, series: [])
//    static var peerSupport = EventCategory(name: "Peer Support", color: Color.PeerSupport, series: [])
//    static var peerEducation = EventCategory(name: "Peer Education", color: Color.PeerEducation, series: [])
//    static var specialEvents = EventCategory(name: "Special Events", color: Color.SpecialEvents, series: [])
//
//    mutating func addEventSeriesToSelf(_ series: EventSeries) {
//        self.series.append(series)
//    }
//
//    func addEventSeriesAndReturn(_ series: EventSeries) -> EventCategory {
//        var copy = self
//        copy.addEventSeriesToSelf(series)
//        return copy
//    }
//}

struct EventSeries: Identifiable, Hashable {
    let id = UUID()
    let name: String
}

//let eventCategories: [EventCategory] = [
//    EventCategory(name: "Family/Caregiver Support", color: Color(hex:"#0c499c"), series: [
//        EventSeries(name: "NAMI Family Support Group")
//    ]),
//    EventCategory(name: "Family/Caregiver Education", color: Color(hex:"#0c499c"), series: [
//        EventSeries(name: "NAMI Family to Family"),
//        EventSeries(name: "NAMI Family & Friends")
//    ]),
//    EventCategory(name: "Peer Support", color: Color(hex:"#0c499c"), series: [
//        EventSeries(name: "Working Well Recovery Support Group"),
//        EventSeries(name: "LGBTQAI+ Connections Support Group"),
//        EventSeries(name: "NAMI Connections Support Group"),
//        EventSeries(name: "Friends Supporting Friends"),
//        EventSeries(name: "Recovery Saturdays")
//    ]),
//    EventCategory(name: "Peer Education", color: Color(hex:"#0c499c"), series: []),
//    EventCategory(name: "Special Events", color: Color(hex:"#0c499c"), series: [])
//]
