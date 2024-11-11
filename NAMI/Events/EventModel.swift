//
//  EventsModel.swift
//  NAMI
//
//  Created by Zachary Tao on 11/10/24.
//

import Foundation

struct Event {
    let title: String
    let location: String
    let date: Date
    let about: String

    let meetingMode: MeetingMode

    static var dummyEvent = Event(title: "Event Title", location: "Event Location", date: Date(), about: "Event Description. This is a very long event description", meetingMode: .virtual(link: "www.zoom.com"))

}
enum MeetingMode {
    case inPerson
    case virtual(link: String)
}
