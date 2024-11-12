//
//  EventsView.swift
//  NAMI
//
//  Created by Zachary Tao on 11/10/24.
//

import SwiftUI

struct EventsView: View {
    @State var searchText = ""
    @State private var selectedGroup = "all"
    @State private var selectedMode = "all"
    var body: some View {
        NavigationStack {
            VStack{
                eventsMenuFilter
                List {


                }
                .searchable(text: $searchText)
            }.navigationTitle("Events")
        }
    }

    var eventsMenuFilter: some View {
        HStack {
            Menu {
                Picker("Group", selection: $selectedGroup) {
                    Text("All Groups").tag("all")
                    Text("Group 1").tag("Group 1")
                    Text("Group 2").tag("Group 2")
                }
            } label: {
                Label("Filter Group", systemImage: "line.horizontal.3.decrease.circle")
            }


            Menu {
                Picker("Mode", selection: $selectedMode) {
                    Label("Virtual", systemImage: "laptopcomputer.and.iphone").tag("virtual")
                    Label("In Person", systemImage: "person.3").tag("in person")
                }
            } label: {
                Label("Mode", systemImage: "line.horizontal.3.decrease.circle")
            }

            Spacer()
        }.padding(.horizontal)
            .buttonStyle(.bordered)
            .foregroundStyle(.black)
            .buttonBorderShape(.capsule)
            .controlSize(.small)

    }
}

#Preview {
    EventsView()
}
