//
//  EventCreationView.swift
//  NAMI
//
//  Created by Riley Koo on 12/2/24.
//

import PhotosUI
import SwiftUI

struct EventCreationView : View {

    @Environment(HomeScreenRouter.self) var homeScreenRouter
    @Environment(EventsViewRouter.self) var eventsViewRouter
    @Environment(TabsControl.self) var tabVisibilityControls
    @State var isImageCompressing = false
    @State var isUploading = false

    var event: Event
    @State var newEvent: Event = Event(title: "",
                                startTime: Calendar.current.date(bySettingHour: 15, minute: 0, second: 0, of: Date())!,
                                endTime: Date(timeInterval: 3600, since: Calendar.current.date(bySettingHour: 15, minute: 0, second: 0, of: Date())!),
                                repeatType: .never,
                                endRepeat: false,
                                endRepeatDate: Date(),
                                about: "",
                                leaderName: "",
                                leaderPhoneNumber: "",
                                meetingMode: .inPerson(location: ""),
                                eventCategory: .familySupport,
                                eventSeries: "",
                                registeredUsersIds: [],
                                imageURL: "")

    @State private var inputMeetingModeText: String = ""
    @State private var showAlert = false
    
    @State private var eventImageItem: PhotosPickerItem?
    @State private var eventImage: UIImage?
    
    @State private var toUpdate: Bool = false

    var body: some View {
        Form {
            Section {
                TextField("Title", text: $newEvent.title)
            }
            Section(footer: Text("Note: time zone is in CST")){
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

            Section(header: Text("Event Series")) {
                TextField("Enter name", text: $newEvent.eventSeries)

            }

            Section(header: Text("Event Leader")) {
                TextField("Name", text: $newEvent.leaderName)
                TextField("Phone Number", text: $newEvent.leaderPhoneNumber).keyboardType(.phonePad)
            }

            Section(header: Text("Event Image")) {
                PhotosPicker(selection: $eventImageItem, matching: .images) {
                    HStack{
                        Text("Select Image")
                        Spacer()
                        if isImageCompressing {
                            ProgressView()
                        }
                    }
                }

                if let eventImage {
                    Image(uiImage: eventImage)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 300, maxHeight: 300)
                }
            }
            .onChange(of: eventImageItem) {
                Task {
                    if let loadedData = try? await eventImageItem?.loadTransferable(type: Data.self),
                       let image = UIImage(data: loadedData)
                    {
                        isImageCompressing = true
                        eventImage = await ImageCompressor.compressAsync(image: image, maxByte: 800000)
                        isImageCompressing = false
                    } else {
                        print("Failed to compress image")
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
                    TextEditorWithPlaceholder(minHeight: 100, bindText: $inputMeetingModeText, placeHolder: "Enter event address")
                        .autocorrectionDisabled()
                case .virtual:
                    TextEditorWithPlaceholder(minHeight: 100, bindText: $inputMeetingModeText, placeHolder: "Enter event zoom link")
                        .autocorrectionDisabled()
                }
            }

            Section(header: Text("Event Description")) {
                TextEditorWithPlaceholder(minHeight: 300, bindText: $newEvent.about, placeHolder: "Enter event details")
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
                message: Text("Something went wrong."),
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

                    Task {
                        withAnimation(.snappy) { isUploading = true }
                        newEvent.imageURL = await EventsManager.shared.uploadImageToStorage(image: eventImage)
                        print("This is new event url: \(newEvent.imageURL)")

                        if toUpdate {
                            if EventsManager.shared.updateEventFromDatabase(event: newEvent) {
                                isUploading = false
                                homeScreenRouter.navigateBack()
                                eventsViewRouter.navigateBack()
                            } else {
                                showAlert = true
                            }
                        }
                        else {
                            if EventsManager.shared.addEventToDatabase(newEvent: newEvent) {
                                isUploading = false
                                homeScreenRouter.navigateBack()
                                eventsViewRouter.navigateBack()
                            } else {
                                showAlert = true
                            }
                        }
                    }
                } label: {
                    HStack {
                        Text("Submit")
                            .bold()
                            .foregroundStyle(isAbleToSubmit() ? .gray : Color.NAMIDarkBlue)
                        if isUploading {
                            ProgressView()
                        }
                    }
                }
                .disabled(isAbleToSubmit())
            }
        }
        .onAppear {
            if event != EventsManager.shared.dummyEvent {
                newEvent = event
                toUpdate = true
            } else {
                toUpdate = false
            }
        }
    }

    func isAbleToSubmit() -> Bool {
        newEvent.title.isEmpty || isUploading || isImageCompressing
    }
}

#Preview {
    NavigationStack {
        EventCreationView(event: EventsManager.shared.dummyEvent)
            .environment(HomeScreenRouter())
            .environment(EventsViewRouter())
            .environment(TabsControl())
    }
}
