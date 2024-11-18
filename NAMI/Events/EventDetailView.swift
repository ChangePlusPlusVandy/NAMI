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
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)
                        .padding(.bottom, 8)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Session Leader/s:")
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text(sessionLeader)
                        .font(.body)
                        .foregroundStyle(.secondary)
                    Text(contact)
                        .font(.body)
                        .foregroundStyle(.secondary)
                }
                        
                Text("Date: \(formattedDate(event.date))")
                    .font(.subheadline)
                    .foregroundStyle(.gray)

                meetingModeSection
                        
                VStack (alignment: .leading, spacing: 8){
                    Text("About")
                        .font(.headline)
                    
                    Text(event.about)
                        .font(.body)
                        .foregroundStyle(.secondary)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Series:")
                        .font(.headline)
                    Text(series)
                        .font(.body)
                        .foregroundColor(.secondary)
                    
                    
                }
                
                VStack (alignment: .leading, spacing: 8){
                    Text("Event Categories:")
                        .font(.headline)
                    Text(eventCategories)
                        .font(.body)
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
        .navigationTitle("Event")
    }
    @ViewBuilder
    private var meetingModeSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Meeting Mode:")
                .font(.headline)
            switch event.meetingMode {
            case .inPerson:
                Text("In-Person")
                    .font(.body)
                    .foregroundStyle(.blue)
            case .virtual(let link):
                Text("Virtual")
                    .font(.body)
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
