//
//  EventCreationView.swift
//  NAMI
//
//  Created by Riley Koo on 12/2/24.
//

import SwiftUI

enum repeatType: String, CaseIterable, Identifiable {
    case None = "None"
    case Daily = "Daily"
    case Weekly = "Weekly"
    case Monthly = "Monthly"
    case Yearly = "Yearly"
    
    var id: String {self.rawValue}
}

func dummyCreate (event: Event, repeat: repeatType) -> Void {
    return
}

struct EventCreationView : View {
    enum fields {
        case None, EventDetails, EventLeader, Series, EventCategories
    }
    @Environment(HomeScreenRouter.self) var homeScreenRouter
    @Environment(EventsViewRouter.self) var eventsViewRouter
    @Environment(TabsControl.self) var tabVisibilityControls
    @State var openField: fields = .None
    
    @State var title: String = ""
    @State var startDate: Date = Date()
    @State var startTime: Date = Date()
    @State var endTime: Date = Date()
    @State var repeatValue: repeatType = .None
    @State var mode: MeetingMode = .inPerson(location: "")
    
    @State var address: String = ""
    @State var link: String = ""
    
    @State var eventLeader: String = ""
    @State var eventDescription: String = ""
    
    @State var seriesName: String = ""
    
    @State var eventCategory: EventCategory? = nil
    
    @State var create: (Event, repeatType)->Void = dummyCreate
    @State var event: Event? = nil
    
    var body: some View {
        ScrollView {
            VStack (spacing: 8) {
                ExpandView(title: "Event Details", expandedBody: EventDetails as! AnyView, selected: $openField, myField: .EventDetails, imageName: "info.circle")
                Spacer()
                    .frame(height: 3)
                ExpandView(title: "Leader", expandedBody: EventLeader as! AnyView, selected: $openField, myField: .EventLeader, imageName: "person.circle")
                Spacer()
                    .frame(height: 3)
                ExpandView(title: "Series", expandedBody: Series as! AnyView, selected: $openField, myField: .Series, imageName: "text.page")
                Spacer()
                    .frame(height: 3)
                ExpandView(title: "Categories", expandedBody: EventCategories as! AnyView, selected: $openField, myField: .EventCategories, imageName: "list.bullet.rectangle")
                Spacer()
                    .frame(height: 6)
                createButton
            }
        }
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
                }
            }

            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    homeScreenRouter.navigateBack()
                    eventsViewRouter.navigateBack()
                } label: {
                    Text("Done")
                        .bold()
                }
            }
        }
    }
    
    var EventDetails: some View {
            VStack (spacing: 8) {
                CustomTextField(text: "Event Title", field: $title)
                
                CustomDatePicker(text: "Date", selection: $startDate, type: .date)
                CustomDatePicker(text: "Start Time", selection: $startTime, type: .hourAndMinute)
                CustomDatePicker(text: "End Time", selection: $endTime, type: .hourAndMinute)
                
                HStack {
                    Spacer()
                        .frame(width: 10)
                    
                    Text("Repeat")
                        .font(.title2)
                    
                    Spacer()
                    
                    Menu {
                        let selected = Binding(
                            get: { repeatValue },
                            set: {
                                self.repeatValue = $0
                            }
                        )
                        
                        Picker("Category", selection: selected) {
                            ForEach(repeatType.allCases){ category in
                                Text(category.rawValue).tag(category)
                            }
                        }
                    } label: {
                        Label(repeatValue.rawValue, systemImage: "chevron.down")
                    }
                    .padding(10)
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.black, lineWidth: 1)
                    }
                    .padding(10)
                    
                    Spacer()
                        .frame(width: 10)
                }
                
                CustomToggle(leftName: "In Person", rightName: "Virtual", mode: $mode, address: $address, link: $link)
                CustomTextField(text: "Event Description", field: $eventDescription, big: true)
                Spacer()
                    .frame(height: 5)
            }
            .padding(10)
    }
    var EventLeader: some View {
        CustomTextField(text: "Event Leader", field: $eventLeader)
    }
    var Series: some View {
        CustomTextField(text: "Series Name", field: $seriesName)
    }
    var EventCategories: some View {
        Menu {
            let selected = Binding(
                get: { eventCategory },
                set: {
                    self.eventCategory = $0 == self.eventCategory ? nil : $0
                }
            )

            Picker("Category", selection: selected) {
                ForEach(EventCategory.allCases){ category in
                    Text(category.rawValue).tag(category)
                }
            }
        } label: {
            Label(eventCategory?.rawValue ?? "All Categories", systemImage: "chevron.down")
        }
        .padding(10)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.black, lineWidth: 1)
        }
        .padding(10)
    }
    var createButton: some View {
        Button {
            var start = DateComponents()
            var end = DateComponents()
            
            var tmp = Calendar.current.dateComponents([.hour, .minute], from: startDate)
            
            start.day = tmp.day
            start.month = tmp.month
            start.year = tmp.year
            
            end.day = tmp.day
            end.month = tmp.month
            end.year = tmp.year
            
            tmp = Calendar.current.dateComponents([.hour, .minute], from: startTime)
            
            start.minute = tmp.minute
            start.hour = tmp.hour
            
            tmp = Calendar.current.dateComponents([.hour, .minute], from: endTime)
            
            end.minute = tmp.minute
            end.hour = tmp.hour
            
            let finalStart = Calendar.current.date(from: start)
            let finalEnd = Calendar.current.date(from: end)
            if (
                finalStart != nil &&
                finalEnd != nil &&
                eventCategory != nil)
            {
                event = Event(
                    title: title,
                    startTime: Calendar.current.date(from: start)!,
                    endTime: Calendar.current.date(from: end)!,
                    about: eventDescription, meetingMode: mode,
                    eventCategory: eventCategory!,
                    eventSeries: EventSeries(name: seriesName)
                )
                if event != nil {
                    create(event!, repeatValue)
                }
            }
        } label: {
            Text("Create")
                .bold()
                .font(.title2)
                .padding(10)
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.black, lineWidth: 1)
                }
        }
    }
    
    struct CustomTextField: View {
        var text: String
        @Binding var field: String
        var big = false
        var body: some View {
            VStack (alignment: .leading, spacing: 8) {
                Text("\(text): ")
                    .bold()
                if big {
                    TextEditor(text: $field)
                        .frame(height: 100)
                        .keyboardType(.default)
                        .padding(.horizontal, 10)
                        .overlay{
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.black, lineWidth: 1)
                        }
                } else {
                    TextField("", text: $field)
                        .frame(height: 50)
                        .keyboardType(.default)
                        .padding(.horizontal, 10)
                        .overlay{
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.black, lineWidth: 1)
                        }
                }
            }.padding(.horizontal, 20)
        }
    }
    struct CustomDatePicker: View {
        var text: String
        @Binding var selection: Date
        var type: DatePickerComponents
        var body: some View {
            HStack {
                DatePicker (
                    text,
                    selection: $selection,
                    displayedComponents: [type]
                )
                .datePickerStyle(.compact)
                .padding(.horizontal, 20)
            }
        }
    }
    struct CustomToggle: View {
        
        @State var leftName: String
        @State var rightName : String
        
        @State var right = false
        @Binding var mode: MeetingMode
        @Binding var address: String
        @Binding var link: String
        
        var body: some View {
            VStack {
                ZStack{
                    Capsule()
                        .stroke(Color.black, lineWidth: 1)
                        .frame(width: 210,height: 60)
                    HStack{
                        ZStack{
                            Capsule()
                                .fill(Color.NAMITealBlue)
                                .frame(width: 93,height: 48)
                            
                                .onTapGesture {
                                    withAnimation {
                                        right.toggle()
                                        if right {
                                            mode = .inPerson(location: "")
                                        } else {
                                            mode = .virtual(link: "")
                                        }
                                    }
                                }
                                .offset(x: right ? 107 : 0)
                            
                            Text("\(leftName)")
                                .bold()
                        }
                        ZStack{
                            Capsule()
                                .fill(.clear)
                                .frame(width: 98,height: 48)
                            Text("\(rightName)")
                                .bold()
                        }
                    }
                }
                if right {
                    CustomTextField(text: "Address", field: $address)
                } else {
                    CustomTextField(text: "Link", field: $link)
                }
            }
        }
    }
    struct ExpandView: View {
        var title: String
        var expandedBody: AnyView
        @Binding var selected: fields
        var myField: fields
        var imageName: String
        var body: some View {
            HStack {
                VStack (alignment: .leading, spacing: 8) {
                    HStack {
                        Text("\(title)")
                            .bold()
                            .padding(10)
                            .onTapGesture {
                                withAnimation {
                                    if selected == myField {
                                        selected = .None
                                    } else {
                                        selected = myField
                                    }
                                }
                            }
                        Image(systemName: "chevron.down")
                        Spacer()
                        Image(systemName: imageName)
                    }
                    if selected == myField {
                        expandedBody
                        Spacer()
                            .frame(height: 10)
                    }
                }
                .transition(.move(edge: .bottom))
                Spacer()
            }
            .padding(.horizontal, 10)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.black, lineWidth: 1)
                    .padding(2)
            }
            .padding(.horizontal, 10)
        }
    }
}

#Preview {
    NavigationStack {
        EventCreationView()
            .environment(HomeScreenRouter())
    }
}
