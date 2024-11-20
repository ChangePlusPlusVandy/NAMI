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
            Event(title: "NAMI Connection Recovery Support Group", startTime: Date(), endTime: Calendar.current.date(byAdding: .hour, value: 2, to: Date())!,  about: "We invite you to join us at NAMI Davidson Co.’s Family Support Group. Family and friends of persons with mental health issues or co-occurring disorders are welcome to this FREE group for persons 18 + years of age.  The group is held in person at Christ Church Nashville, 15354 Old Hickory Blvd, Nashville, TN 37211 in their Hospitality Room. The group starts at 3pm and ends at 5pm. Please complete registration and information / directions will be emailed to you.  Our support groups follow a guided program format and are always a safe place for emotional expression.", meetingMode: .inPerson(location: "Here"), eventCategory: EventCategory.peerSupport, eventSeries: EventSeries(name: "NAMI Connection")),
            Event(title: "NAMI Family Support Group", startTime: Date(), endTime: Calendar.current.date(byAdding: .hour, value: 2, to: Date())!, about: "Please register to join us for our 90 minute mental health caregiver primer for people with a loved one living with a mental health condition.   The seminar is led by trained people with lived experience of supporting a family member with a mental health condition. They will walk you through the following topics: understanding diagnoses, treatment and recovery; effective communication strategies; the importance of self-care; crisis preparation strategies; and, NAMI and community resources.", meetingMode: .virtual(link: "http://www.zoom.com"), eventCategory: EventCategory.familySupport, eventSeries: EventSeries(name: "NAMI Family Support")),
            Event(title: "Family & Friends Mental Health Caregiver Primer", startTime: Date(), endTime: Calendar.current.date(byAdding: .hour, value: 2, to: Date())!, about: "The presenter will discuss an overview of perinatal mood and anxiety disorders, including important statistics, risk factors, and common signs and symptoms. The presentation will cover warning signs and identify ways that individuals can determine if a loved one could benefit from additional support.   In addition, the session will include helpful ideas and approaches to engage in self-care, self-compassion, and resources to reduce or prevent the escalation of distress in pregnancy and the postpartum period.", meetingMode: .virtual(link: "http://www.zoom.com"), eventCategory: EventCategory.specialEvents)
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
