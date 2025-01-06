//
//  EventCreationView.swift
//  NAMI
//
//  Created by Riley Koo on 12/2/24.
//

import SwiftUI
import FirebaseFirestore

struct EventCreationView : View {

    @Environment(HomeScreenRouter.self) var homeScreenRouter
    @Environment(EventsViewRouter.self) var eventsViewRouter
    @Environment(TabsControl.self) var tabVisibilityControls
    @State private var alertMessage: String? = nil
    @State private var showAlert = false

    @State var newEvent = Event(title: "",
                                startTime: Date(),
                                endTime: Date(timeIntervalSinceNow: 3600),
                                repeatType: .never,
                                endRepeat: false,
                                endRepeatDate: Date(),
                                about: "",
                                leaderName: "",
                                leaderPhoneNumber: "",
                                meetingMode: .inPerson(location: ""),
                                eventCategory: .familyEducation)

    @State private var inputMeetingModeText: String = ""

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
            .onChange(of: newEvent.startTime) {
                if newEvent.startTime > newEvent.endTime {
                    newEvent.endTime = newEvent.startTime + 3600
                }
            }

            Section {
                HStack {
                    Text("Repeat")
                    Spacer()
                    Menu {
                        Picker("Category", selection: $newEvent.repeatType) {
                            ForEach(RepeatType.allCases){ category in
                                Text(category.rawValue).tag(category)
                            }
                        }
                    } label: {
                        HStack {
                            Text(newEvent.repeatType.rawValue)
                            Image(systemName: "chevron.up.chevron.down")
                                .imageScale(.small)
                        }
                        .foregroundStyle(.secondary)
                    }
                }
                if newEvent.repeatType != .never {
                    HStack {
                        Text("End Repeat")
                        Spacer()
                        Menu {
                            Picker("Category", selection: $newEvent.endRepeat) {
                                Text("Never").tag(false)
                                Text("On Date").tag(true)
                            }
                        } label: {
                            HStack {
                                Text(newEvent.endRepeat ? "On Date" : "Never")
                                Image(systemName: "chevron.up.chevron.down")
                                    .imageScale(.small)
                            }
                            .foregroundStyle(.secondary)
                        }
                    }
                }

                if newEvent.repeatType != .never && newEvent.endRepeat {
                    DatePicker("End Date", selection: $newEvent.endRepeatDate, displayedComponents: .date)
                        .tint(Color.NAMIDarkBlue)
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
                .onChange(of: newEvent.meetingMode) { inputMeetingModeText = "" }

                switch newEvent.meetingMode {
                case .inPerson:
                    TextEditorWithPlaceholder(minHeight: 150, bindText: $inputMeetingModeText, placeHolder: "Enter event address")
                        .autocorrectionDisabled()
                case .virtual:
                    TextEditorWithPlaceholder(minHeight: 150, bindText: $inputMeetingModeText, placeHolder: "Enter event zoom link")
                        .autocorrectionDisabled()
                }
            }

            Section(header: Text("Event Description")) {
                TextEditorWithPlaceholder(minHeight: 300, bindText: $newEvent.about, placeHolder: "Enter event details")
            }

            Section(header: Text("Event Leader")) {
                TextField("Name", text: $newEvent.leaderName)
                TextField("Phone Number", text: $newEvent.leaderPhoneNumber).keyboardType(.phonePad)
            }
        }
        .scrollDismissesKeyboard(.interactively)
        .scrollIndicators(.hidden)
        .navigationTitle("Create Event")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Error Submitting Event"),
                message: Text(alertMessage ?? "Something went wrong."),
                dismissButton: .default(Text("OK"))
            )
        }
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
                    newEvent.meetingMode = newEvent.meetingMode.updateLocationOrLink(with: inputMeetingModeText)

                    if addEventToDatabase() {
                        homeScreenRouter.navigateBack()
                        eventsViewRouter.navigateBack()
                    }
                } label: {
                    Text("Submit")
                        .bold()
                        .foregroundStyle(newEvent.title.isEmpty ? .gray : Color.NAMIDarkBlue)
                }
                .disabled(newEvent.title.isEmpty)
            }
        }
    }

    private func addEventToDatabase() -> Bool {
        do {
            try Firestore.firestore().collection("events").addDocument(from: newEvent)
            return true
        } catch {
            alertMessage = error.localizedDescription
            showAlert = true
            return false
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
