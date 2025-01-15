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

    @State private var inputMeetingModeText: String = ""
    @State private var showAlert = false

    @State private var eventImageItem: PhotosPickerItem?
    @State private var eventImage: UIImage?

    @State var event: Event
    var isEdit: Bool

    var body: some View {
        Form {
            Section {
                TextField("Title", text: $event.title)
            }
            Section(footer: Text("Note: time zone is in CST")){
                DatePicker("Starts", selection: $event.startTime)
                DatePicker("Ends", selection: $event.endTime)
            }
            .tint(Color.NAMIDarkBlue)
            .onChange(of: event.startTime) {
                if event.startTime > event.endTime {
                    event.endTime = event.startTime + 3600
                }
            }

            Section {
                HStack {
                    Text("Repeat")
                    Spacer()
                    Menu {
                        Picker("Category", selection: $event.repeatType) {
                            ForEach(RepeatType.allCases){ category in
                                Text(category.rawValue).tag(category)
                            }
                        }
                    } label: {
                        HStack {
                            Text(event.repeatType.rawValue)
                            Image(systemName: "chevron.up.chevron.down")
                                .imageScale(.small)
                        }
                        .foregroundStyle(.secondary)
                    }
                }
                if event.repeatType != .never {
                    HStack {
                        Text("End Repeat")
                        Spacer()
                        Menu {
                            Picker("Category", selection: $event.endRepeat) {
                                Text("Never").tag(false)
                                Text("On Date").tag(true)
                            }
                        } label: {
                            HStack {
                                Text(event.endRepeat ? "On Date" : "Never")
                                Image(systemName: "chevron.up.chevron.down")
                                    .imageScale(.small)
                            }
                            .foregroundStyle(.secondary)
                        }
                    }
                }

                if event.repeatType != .never && event.endRepeat {
                    DatePicker("End Date", selection: $event.endRepeatDate, displayedComponents: .date)
                        .tint(Color.NAMIDarkBlue)
                }
            }

            Section {
                HStack{
                    Text("Event Category")
                    Spacer()
                    Menu {
                        Picker("Category", selection: $event.eventCategory) {
                            ForEach(EventCategory.allCases){ category in
                                Text(category.rawValue).tag(category)
                            }
                        }
                    } label: {
                        HStack {
                            Text(event.eventCategory.rawValue)
                            Image(systemName: "chevron.up.chevron.down")
                                .imageScale(.small)
                        }
                        .foregroundStyle(.secondary)
                    }
                }
            }

            Section(header: Text("Event Series")) {
                TextField("Enter name", text: $event.eventSeries)

            }

            Section(header: Text("Event Leader")) {
                TextField("Name", text: $event.leaderName)
                TextField("Phone Number", text: $event.leaderPhoneNumber).keyboardType(.phonePad)
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
                Picker("", selection: $event.meetingMode) {
                    Text(MeetingMode.inPerson(location: "").displayName)
                        .tag(MeetingMode.inPerson(location: ""))
                    Text(MeetingMode.virtual(link: "").displayName)
                        .tag(MeetingMode.virtual(link: ""))
                }
                .pickerStyle(SegmentedPickerStyle())
                .onChange(of: event.meetingMode) { inputMeetingModeText = "" }

                switch event.meetingMode {
                case .inPerson:
                    TextEditorWithPlaceholder(minHeight: 100, bindText: $inputMeetingModeText, placeHolder: "Enter event address")
                        .autocorrectionDisabled()
                case .virtual:
                    TextEditorWithPlaceholder(minHeight: 100, bindText: $inputMeetingModeText, placeHolder: "Enter event zoom link")
                        .autocorrectionDisabled()
                }
            }

            Section(header: Text("Event Description")) {
                TextEditorWithPlaceholder(minHeight: 300, bindText: $event.about, placeHolder: "Enter event details")
            }
        }
        .scrollDismissesKeyboard(.interactively)
        .scrollIndicators(.hidden)
        .navigationTitle(isEdit ? "Edit Event" : "Create Event")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Error Submitting Event"),
                message: Text("Something went wrong."),
                dismissButton: .default(Text("OK"))
            )
        }
        .onAppear(perform: fetchCurrentEventImage)
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
                    event.meetingMode = event.meetingMode.updateLocationOrLink(with: inputMeetingModeText)

                    Task {
                        withAnimation(.snappy) { isUploading = true }
                        EventsManager.shared.deleteImageFromStorage(imageURL: event.imageURL)
                        event.imageURL = await EventsManager.shared.uploadImageToStorage(image: eventImage)
                        print("This is new event url: \(event.imageURL)")

                        if EventsManager.shared.addEventToDatabase(newEvent: event, isEdit: isEdit) {
                            isUploading = false
                            homeScreenRouter.navigateToRoot()
                            eventsViewRouter.navigateToRoot()
                        } else {
                            showAlert = true
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
    }

    func isAbleToSubmit() -> Bool {
        event.title.isEmpty || isUploading || isImageCompressing
    }

    func fetchCurrentEventImage() {
        guard let url = URL(string: event.imageURL) else { return }
        DispatchQueue.global().async {
            guard let data = try? Data(contentsOf: url) else { return }
            DispatchQueue.main.async {
                guard let dataImage = UIImage(data: data) else { return }
                eventImage = dataImage
            }
        }
    }
}

#Preview {
    NavigationStack {
        EventCreationView(event: Event.newEvent, isEdit: false)
            .environment(HomeScreenRouter())
            .environment(EventsViewRouter())
            .environment(TabsControl())
    }
}
