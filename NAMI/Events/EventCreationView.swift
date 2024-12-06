//
//  EventCreationView.swift
//  NAMI
//
//  Created by Riley Koo on 12/2/24.
//

import SwiftUI

struct EventCreationView : View {

    @Environment(HomeScreenRouter.self) var homeScreenRouter
    @Environment(EventsViewRouter.self) var eventsViewRouter
    @Environment(TabsControl.self) var tabVisibilityControls

    @State var eventLeader: String = ""
    @State var eventDescription: String = ""
    @State var selectedRepeating = RepeatType.never

    @State var seriesName: String = ""
    @State var showEndRepeat = false
    @State var newEvent = Event(title: "", startTime: Date(), endTime: Date(), about: "", meetingMode: .inPerson(location: ""), eventCategory: .familyEducation)
    var body: some View {
        Form {
            Section {
                TextField("Title", text: $newEvent.title)
            }

            Section {
                DatePicker("Starts", selection: $newEvent.startTime)

                DatePicker("Ends", selection: $newEvent.endTime)
            }
            .tint(Color.NAMIDarkBlue)

            Section {
                HStack {
                    Text("Repeat")
                    Spacer()
                    Menu {
                        Picker("Category", selection: $selectedRepeating) {
                            ForEach(RepeatType.allCases){ category in
                                Text(category.rawValue).tag(category)
                            }
                        }
                    } label: {
                        HStack {
                            Text(selectedRepeating.rawValue)
                            Image(systemName: "chevron.up.chevron.down")
                                .imageScale(.small)
                        }
                        .foregroundStyle(.secondary)
                    }
                }
                if selectedRepeating != .never {
                    HStack {
                        Text("End Repeat")
                        Spacer()
                        Menu {
                            Picker("Category", selection: $showEndRepeat) {
                                Text("Never").tag(false)
                                Text("On Date").tag(true)
                            }
                        } label: {
                            HStack {
                                Text(showEndRepeat ? "On Date" : "Never")
                                Image(systemName: "chevron.up.chevron.down")
                                    .imageScale(.small)
                            }
                            .foregroundStyle(.secondary)
                        }
                    }
                }
                if selectedRepeating != .never && showEndRepeat {
                    DatePicker("End Date", selection: $newEvent.endRepeatDate, displayedComponents: .date)
                }
            }

            Section {
                HStack{
                    Text("Event Category")
                    Spacer()
                    Menu {
                        Picker("Category", selection: $newEvent.eventCategory) {
                            ForEach(EventCategory.allCases){ category in
                                Text(category.rawValue).tag(category)
                            }
                        }
                    } label: {
                        HStack {
                            Text(newEvent.eventCategory.rawValue)
                            Image(systemName: "chevron.up.chevron.down")
                                .imageScale(.small)
                        }
                        .foregroundStyle(.secondary)
                    }
                }
            }

            Section(header: Text("Meeting Mode")) {
                Picker("", selection: $newEvent.meetingMode) {
                    Text(MeetingMode.inPerson(location: "").displayName)
                        .tag(MeetingMode.inPerson(location: ""))
                    Text(MeetingMode.virtual(link: "").displayName)
                        .tag(MeetingMode.virtual(link: ""))
                }
                .pickerStyle(SegmentedPickerStyle())

                switch newEvent.meetingMode {
                case .inPerson:
                    TextEditorWithPlaceholder(minHeight: 150, bindText: .constant(""), placeHolder: "Enter event address")
                case .virtual:
                    TextEditorWithPlaceholder(minHeight: 150, bindText: .constant(""), placeHolder: "Enter event zoom link")
                }
            }

            Section(header: Text("Event Description")) {
                TextEditorWithPlaceholder(minHeight: 300, bindText: $eventDescription, placeHolder: "Enter event details")
            }

            Section(header: Text("Event Leader")) {
                TextField("Leader Name", text: $eventLeader)
            }
        }
        .scrollDismissesKeyboard(.interactively)
        .navigationTitle("Create Event")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    homeScreenRouter.navigateBack()
                    eventsViewRouter.navigateBack()
                } label: {
                    Text("Cancel")
                        .foregroundStyle(Color.NAMIDarkBlue)
                }
            }

            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    homeScreenRouter.navigateBack()
                    eventsViewRouter.navigateBack()
                } label: {
                    Text("Submit")
                        .bold()
                        .foregroundStyle(Color.NAMIDarkBlue)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        EventCreationView()
            .environment(HomeScreenRouter())
            .environment(EventsViewRouter())
            .environment(TabsControl())
    }
}
