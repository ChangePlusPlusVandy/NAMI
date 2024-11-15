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
    var selectedSeries: EventSeries?
    var selectedMeetingMode: MeetingMode?

    init() {
        // dummy data
        allEvents = [
            Event(title: "Event 1", location: "Location 1", date: Date(), about: "About 1", meetingMode: .inPerson, eventCategory: EventCategory.familyCaregiverSupport),
            Event(title: "Event 2", location: "Location 2", date: Date(), about: "About 2", meetingMode: .virtual(link: "www.zoom.com"), eventCategory: EventCategory.familyCaregiverEducation.addEventSeriesAndReturn(EventSeries(name: "NAMI Family to Family")))
        ]
    }

    var filteredEvents: [Event] {
        allEvents.filter { event in
            (selectedCategory == nil || event.eventCategory.name == selectedCategory?.name) &&
            (selectedSeries == nil || event.eventCategory.series.contains(where: { $0.name == selectedSeries?.name })) &&
            (searchText.isEmpty || event.title.localizedCaseInsensitiveContains(searchText) || event.about.localizedCaseInsensitiveContains(searchText)) &&
            (selectedMeetingMode == nil || event.meetingMode == selectedMeetingMode)
        }
    }

    func resetFilters() {
        selectedCategory = nil
        selectedSeries = nil
        searchText = ""
    }
}
