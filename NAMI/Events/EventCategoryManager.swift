//
//  EventCategoryManager.swift
//  NAMI
//
//  Created by Zachary Tao on 11/14/24.
//

import Foundation

@Observable
class EventsManager {
    var allEvents: [Event] = []
    var searchText = ""

    var selectedCategory: EventCategory?
    var selectedMeetingMode: MeetingMode?

    init() {
        // dummy data
        allEvents = [
            Event(title: "NAMI Connection Recovery Support Group", date: Date(), about: "About 1", meetingMode: .inPerson(location: "Here"), eventCategory: EventCategory.peerSupport),
            Event(title: "NAMI Family Support Group", date: Date(), about: "About 2", meetingMode: .virtual(link: "www.zoom.com"), eventCategory: EventCategory.familySupport),
            Event(title: "Family & Friends Mental Health Caregiver Primer", date: Date(), about: "About 3", meetingMode: .virtual(link: "www.zoom.com"), eventCategory: EventCategory.specialEvents)
        ]
    }

    var filteredEvents: [Event] {
        allEvents.filter { event in
            (selectedCategory == nil || event.eventCategory == selectedCategory) &&
            (searchText.isEmpty || event.title.localizedCaseInsensitiveContains(searchText) || event.about.localizedCaseInsensitiveContains(searchText)) &&
            (selectedMeetingMode == nil || event.meetingMode.displayName == selectedMeetingMode?.displayName)
        }
    }

    func resetFilters() {
        selectedCategory = nil
        searchText = ""
    }
}
