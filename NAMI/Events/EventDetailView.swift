//
//  EventDetailView.swift
//  NAMI
//
//  Created by Zachary Tao on 11/10/24.
//

import SwiftUI

struct EventDetailView: View {
    @Environment(EventsViewRouter.self) var eventsViewRouter
    var event: Event
    var sessionLeader: String = "Amy Cliff"
    var contact: String = "909-000-1827"
    var series: String = "Ex: Family-To-Family Class- In-Person"
    var eventCategories: String = "Ex: Education, NAMI \nFamily-to-Family, NAMI \nWilliamson and Maury County TN"
    // TODO: Implement Event detail view from the event object
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(event.title)
                    .franklinGothic(.bold, 34)
                    .multilineTextAlignment(.leading)
                        .padding(.bottom, 8)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Session Leader/s:")
                        .franklinGothic(.regular, 17)
                        .foregroundColor(.primary)
                    Text(sessionLeader)
                        .proximaNova(.regular, 17)
                        .foregroundStyle(.secondary)
                    Text(contact)
                        .proximaNova(.regular, 17)
                        .foregroundStyle(.secondary)
                }
                        
                Text("Date: \(formattedDate(event.startTime))")
                    .proximaNova(.regular, 15)
                    .foregroundStyle(.gray)

                meetingModeSection
                        
                VStack (alignment: .leading, spacing: 8){
                    Text("About")
                        .proximaNova(.regular, 17)
                    
                    Text(event.about)
                        .proximaNova(.regular, 17)
                        .foregroundStyle(.secondary)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Series:")
                        .proximaNova(.regular, 17)
                    Text(series)
                        .proximaNova(.regular, 17)
                        .foregroundColor(.secondary)
                    
                    
                }
                
                VStack (alignment: .leading, spacing: 8){
                    Text("Event Categories:")
                        .proximaNova(.regular, 17)
                    Text(eventCategories)
                        .proximaNova(.regular, 17)
                        .foregroundStyle(.secondary)
                }
                
                
            }
            .padding()
        }
        .background(LinearGradient(
            gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.white]),
            startPoint: .top,
            endPoint: .bottom
        ))
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Event")
                    .franklinGothic(.regular, 28)
            }
        }
    }
    @ViewBuilder
    private var meetingModeSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Meeting Mode:")
                .proximaNova(.regular, 17)
            switch event.meetingMode {
            case .inPerson:
                Text("In-Person")
                    .proximaNova(.regular, 17)
                    .foregroundStyle(.blue)
            case .virtual(let link):
                Text("Virtual")
                    .proximaNova(.regular, 17)
                    .foregroundColor(.blue)
                HStack {
                    
                    if let url = URL(string: link) {
                        Link(link, destination: url)
                            .foregroundStyle(.blue)
                        Button(action: {
                            UIPasteboard.general.string = link
                        }) {
                            Image(systemName: "doc.on.doc")
                                .foregroundStyle(.gray)
                            }
                        }
                    }
                }
            }
        }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

#Preview {
    EventDetailView(event: Event.dummyEvent)
        .environment(EventsViewRouter())
}
