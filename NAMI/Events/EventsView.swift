//
//  EventsView.swift
//  NAMI
//
//  Created by Zachary Tao on 11/10/24.
//

import SwiftUI

struct EventsView: View {
    @State var eventsManager = EventsManager()

    var body: some View {
        NavigationStack {
            VStack {
                eventsMenuFilter
                List {


                }
                .searchable(text: $eventsManager.searchText)
            }.navigationTitle("Events")
        }
    }

    var eventsMenuFilter: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                Menu{
                    let selected = Binding(
                        get: { eventsManager.selectedCategory },
                        set: {
                            self.eventsManager.selectedCategory = $0 == self.eventsManager.selectedCategory ? nil : $0
                            self.eventsManager.selectedSeries = nil
                        }
                    )

                    Picker("Category", selection: selected) {
                        ForEach(eventCategories, id: \.self){ category in
                            Text(category.name).tag(category)
                        }
                    }
                } label: {
                    let selectedCategory = eventsManager.selectedCategory
                    Label(selectedCategory == nil ? "Category" : selectedCategory!.name, systemImage: "chevron.down")
                }.animation(.none, value: eventsManager.selectedCategory)

                if let series = eventsManager.selectedCategory?.series, !series.isEmpty {
                    Menu{
                        let selected = Binding(
                            get: { eventsManager.selectedSeries },
                            set: { self.eventsManager.selectedSeries = $0 == self.eventsManager.selectedSeries ? nil : $0 }
                        )
                        Picker("Series", selection: selected) {
                            ForEach(series, id: \.self){ s in
                                Text(s.name).tag(s)
                            }
                        }
                    } label: {
                        let selectedSeries = eventsManager.selectedSeries
                        Label(selectedSeries == nil ? "Series" : selectedSeries!.name, systemImage: "chevron.down")
                    }.animation(.none, value: eventsManager.selectedSeries)
                }

                Menu {
                    let selected = Binding(
                        get: { eventsManager.selectedMeetingMode },
                        set: { self.eventsManager.selectedMeetingMode = $0 == self.eventsManager.selectedMeetingMode ? nil : $0 }
                    )
                    Picker("Mode", selection: selected) {
                        Label("Virtual", systemImage: "laptopcomputer.and.iphone").tag(MeetingMode.virtual(link: ""))
                        Label("In Person", systemImage: "person.3").tag(MeetingMode.inPerson)
                    }
                } label: {
                    let selectedMeetingMode = eventsManager.selectedMeetingMode
                    Label(selectedMeetingMode == nil ? "Mode" : selectedMeetingMode!.displayName, systemImage: "chevron.down")
                }.animation(.none, value: eventsManager.selectedMeetingMode)
            }
            .labelStyle(CustomFilterLabelStyle())
            .padding(.horizontal)
            .buttonStyle(.bordered)
            .buttonBorderShape(.capsule)
            .animation(.default, value: eventsManager.selectedCategory)
            .animation(.default, value: eventsManager.selectedSeries)
            .animation(.default, value: eventsManager.selectedMeetingMode)
        }
    }
}

#Preview {
    EventsView()
}
