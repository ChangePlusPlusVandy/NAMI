//
//  EventsModel.swift
//  NAMI
//
//  Created by Zachary Tao on 11/10/24.
//

struct Event {
    let title: String
    let location: String
    let date: String // tempoary using string, will change to Date
    let about: String

    let meetingMode: MeetingMode
}
enum MeetingMode {
    case inPerson
    case virtual(link: String)
}
