//
//  EventDetailView.swift
//  NAMI
//
//  Created by Zachary Tao on 11/10/24.
//
import SwiftUI
struct EventDetailView: View {
    @Environment(EventsViewRouter.self) var eventsViewRouter
    @State private var showPopup = false
    
    var event: Event
    var sessionLeader: String = "Amy Cliff"
    var contact: String = "909-000-1827"
    var series: String = "Ex: Family-To-Family Class- In-Person"
    var eventCategories: String = "Ex: Education, NAMI \nFamily-to-Family, NAMI \nWilliamson and Maury County TN"
    var body: some View {
        ScrollView(showsIndicators: false) {
            ZStack {
                VStack(alignment: .leading, spacing: 20) {
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text(event.title)
                            .font(.title.bold())
                        Text("\(formattedDate(event.startTime))")
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 15)
                    
                    AsyncImage(url: URL(string: event.imageURL)) { image in
                                        image.resizable()
                        .scaledToFit()
                    } placeholder: {
                    }


                    
                    VStack(alignment: .leading) {
                        Text("Session Leader/s:")
                            .font(.title3.bold())
                            .padding(.vertical, 3)
                        
                        Text(sessionLeader)
                        Text(contact)
                    }
                    
                    meetingModeSection
                    
                    VStack(alignment: .leading) {
                        Text("About:")
                            .font(.title3.bold())
                            .padding(.vertical, 3)
                        Text(event.about)
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Series:")
                            .font(.title3.bold())
                            .padding(.vertical, 3)
                        Text(series)
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Event Categories:")
                            .font(.title3.bold())
                            .padding(.vertical, 3)
                        Text(eventCategories)
                    }
                    Spacer()
                    
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            
                            Button(action: {
                                showPopup = true
                            }){
                                Label("Register", systemImage: "checkmark.rectangle.portrait")
                            }
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: UIScreen.main.bounds.width / 2)
                            .background(Color.blue)
                            .cornerRadius(20)
                            
                        }
                        .padding(.bottom, 16)
                    }
                }
                .font(.footnote)
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
                
                if showPopup {
                    Color.black.opacity(0.4)
                        .edgesIgnoringSafeArea(.all)
                    VStack(spacing: 16){
                        HStack{
                            Text("Registration Complete")
                                .font(.title)
                                .foregroundColor(.blue)
                            Spacer()
                            Image(systemName: "checkmark")
                                .font(.title2)
                                .foregroundColor(.blue)
                        }
                        .padding(.top)
                        .padding(.horizontal, 20)
                        Text("""
                             You are one step closer to \ngetting the support you deserve!
                             """)
                        .multilineTextAlignment(.leading)
                        .font(.body)
                        .foregroundColor(.black)
                        Text("""
                             You can find the meeting, time,\nlocation, and any details you\nmight need from the home page.
                             """)
                        .multilineTextAlignment(.leading)
                        .font(.body)
                        .foregroundColor(.black)
                        Text("""
                             We will always send a reminder\nabout the event 1hr before it \nstarts.
                             """)
                        .multilineTextAlignment(.leading)
                        .font(.body)
                        .foregroundColor(.black)
                        Button(action: {showPopup = false
                        }) {
                            Text("Back To Home")
                                .foregroundColor(.blue)
                                .font(.body)
                                .underline()
                        }
                        .padding(.bottom, 20)
                    }
                    
                    .frame(width: 300, height: 400)
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(radius: 10)
                    .padding()
                }
            }
        }
        .navigationTitle("")
    }
    @ViewBuilder
    private var meetingModeSection: some View {
        VStack(alignment: .leading) {
            Text("Meeting Mode:")
                .font(.title3.bold())
                .padding(.vertical, 3)
            switch event.meetingMode {
            case .inPerson:
                Text("In Person")
            case .virtual(let link):
                Text("Virtual")
                HStack {
                    if let url = URL(string: link) {
                        Link(link, destination: url)
                            .foregroundStyle(.blue)
                        Button {
                            UIPasteboard.general.string = link
                        } label: {
                            Image(systemName: "doc.on.doc")
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


