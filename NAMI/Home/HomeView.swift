//
//  HomeView.swift
//  NAMI
//
//  Created by Zachary Tao on 11/10/24.
//

import SwiftUI
import FirebaseFirestore

struct HomeView: View {
    @Environment(AuthenticationManager.self) var authManager
    @Environment(TabsControl.self) var tabVisibilityControls
    @State var homeScreenRouter = HomeScreenRouter()
    @State private var viewModel = HomeViewModel()
    @State private var calendarManager = CalendarManager()

    var body: some View {
        NavigationStack(path: $homeScreenRouter.navPath) {
            VStack (alignment: .leading){
                Text("Welcome")
                    .font(.largeTitle.bold())
                    .padding([.bottom, .horizontal])
                    .padding(.top, 10)

                Text("My Upcoming Events")
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal)
                    .padding(.bottom, 5)

                CalendarDisplaySelectionButton()
                    .environment(calendarManager)
                    .padding(.horizontal)

                switch calendarManager.viewOption {
                case .calendar:
                    Group {
                        Group {
                            CalendarSelectionHeader()
                                .padding(.vertical, 8)
                            CalendarGrid(events: viewModel.registeredEvents)
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 6)

                        let filteredEvents = viewModel.getEventsOnDate(calendarManager.selectedDate)
                        if !filteredEvents.isEmpty {
                            List(filteredEvents) { event in
                                CustomEventCardView(event: event)
                                    .onTapGesture {
                                        tabVisibilityControls.makeHidden()
                                        homeScreenRouter.navigate(to: .eventDetailView(event: event))
                                    }
                            }
                            .listStyle(.plain)
                            .scrollIndicators(.hidden)
                        } else {
                            emptyStateView
                        }
                    }
                    .environment(calendarManager)
                    .environment(homeScreenRouter)
                    .transition(.move(edge: .trailing))
                case .list:
                    if viewModel.registeredEvents.isEmpty {
                        noEventsView
                            .transition(.move(edge: .leading))
                    } else {
                        List(viewModel.registeredEvents) { event in
                            CustomEventCardView(event: event)
                                .onTapGesture {
                                    tabVisibilityControls.makeHidden()
                                    homeScreenRouter.navigate(to: .eventDetailView(event: event))
                                }
                        }
                        .listStyle(.plain)
                        .scrollIndicators(.hidden)
                        .refreshable {viewModel.refreshRegisteredEvents()}
                        .transition(.move(edge: .leading))
                    }
                }
            }
            .toolbar {homeViewToolBar}
            .sheet(isPresented: $calendarManager.showMonthYearPicker){
                MonthYearPickerView(
                    isPresented: $calendarManager.showMonthYearPicker,
                    selectedDate: $calendarManager.currentMonth,
                    onDateSelected: { date in calendarManager.selectDate(date) }
                )
            }
            .navigationTitle("")
            .navigationDestination(for: HomeScreenRouter.Destination.self) { destination in
                switch destination {
                case .userProfileView:
                    UserProfileView()
                        .environment(homeScreenRouter)
                case .userProfileEditView:
                    UserProfileEditView()
                        .environment(homeScreenRouter)
                case .adminEventCreationView(let event):
                    EventCreationView(event: event, isEdit: false)
                        .environment(homeScreenRouter)
                        .environment(EventsViewRouter())
                case .eventDetailView(let event):
                    EventDetailView(event: event)
                        .environment(homeScreenRouter)
                        .environment(EventsViewRouter())
                }
            }
            .onAppear {
                tabVisibilityControls.makeVisible()
                viewModel.refreshRegisteredEvents()
            }
            .onChange(of: UserManager.shared.currentUser?.registeredEventsIds) {
                viewModel.refreshRegisteredEvents()
            }
        }
    }
    
    private var noEventsView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Text("You have no upcoming events")
                .font(.title3)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
            
            Text("Take a look at new events posted and sign up")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button {
                // Navigate to Events tab
                
            } label: {
                Text("Events")
                    .fontWeight(.medium)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 12)
                    .background(Color(red: 0.33, green: 0.65, blue: 0.67)) // Teal color like in the image
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding(.top, 10)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(UIColor.systemBackground))
    }

    struct CustomEventCardView: View {
        @State var showConfirmationDialog = false
        let event: Event
        var body: some View {
            EventCardView(event: event, showRegistered: false)
                .listRowSeparator(.hidden, edges: .all)
                .contextMenu {
                    Button("Cancel Registration", systemImage: "calendar.badge.minus") { showConfirmationDialog = true}
                        .tint(.red)
                }
                .swipeActions {
                    Button("", systemImage: "calendar.badge.minus") { showConfirmationDialog = true}
                        .tint(.red)
                }
                .confirmationDialog(
                    "Are you sure you want to cancel registration for this event?",
                    isPresented: $showConfirmationDialog,
                    titleVisibility: .visible
                ) {
                    Button("Cancel Registration", role: .destructive) {
                        if let targetEventId = event.id {
                            EventsManager.shared.cancelRegistrationForEvent(eventId: targetEventId, userId: UserManager.shared.userID)
                        }
                    }
                }
        }
    }

    @ToolbarContentBuilder
    var homeViewToolBar: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading){
            HStack(spacing: 0) {
                Image("NAMIDavidson")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 28)
            }
        }

        if UserManager.shared.isAdmin() {
            ToolbarItem(placement: .topBarTrailing){
                Button{
                    tabVisibilityControls.makeHidden()
                    homeScreenRouter.navigate(to: .adminEventCreationView(event: Event.newEvent))
                } label: {
                    Image(systemName: "plus.app")
                }
            }
        }

        ToolbarItem(placement: .topBarTrailing) {
            Button {
                tabVisibilityControls.makeHiddenNoAnimation()
                homeScreenRouter.navigate(to: .userProfileView)
            } label: {
                Image(systemName: "person.fill")
            }
        }
    }

    private var emptyStateView: some View {
        VStack {
            Image(systemName: "calendar.circle.fill")
                .font(.largeTitle)
                .foregroundStyle(.secondary)

            Text("No events registered on this date")
                .font(.headline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .listRowSeparator(.hidden, edges: .all)
        .frame(maxHeight: .infinity)
    }
}

@Observable
@MainActor
class HomeViewModel {
    var registeredEvents: [Event] = []
    private let db = Firestore.firestore()

    func refreshRegisteredEvents() {
        Task {
            var registeredEventsIds = UserManager.shared.currentUser?.registeredEventsIds ?? []
            if registeredEventsIds.isEmpty {
                registeredEventsIds.append("temp")
            }
            let query = db.collection("events")
                .whereField(FieldPath.documentID(), in: registeredEventsIds)
                .order(by: "startTime", descending: false)
            let documents = try await query.getDocuments().documents
            let events = documents.compactMap { try? $0.data(as: Event.self) }
            print("Registered events are refreshed")
            print("registered evnets count \(registeredEvents.count)")
            withAnimation {
                registeredEvents = events
            }
        }
    }

    func getEventsOnDate(_ date: Date) -> [Event] {
        registeredEvents.filter { event in  // Assuming viewModel has an events property
            Calendar.current.isDate(event.startTime, inSameDayAs: date)
        }
    }
}

#Preview {
    HomeView()
        .environment(AuthenticationManager())
        .environment(TabsControl())
        .environment(EventsViewRouter())
}
