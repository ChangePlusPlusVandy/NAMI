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
    @State private var hasAppeared = false

    var body: some View {
        NavigationStack(path: $homeScreenRouter.navPath) {
            VStack (alignment: .leading){
                Text("Welcome")
                    .font(.largeTitle.bold())
                    .padding([.bottom, .horizontal])
                    .padding(.top, 10)

                if UserManager.shared.userType == .member {
                    Text("My Upcoming Events")
                        .font(.callout)
                        .foregroundStyle(.secondary)
                        .padding()
                    List {
                        ForEach(viewModel.registeredEvents) { event in
                            CustomEventCardView(event: event)
                                .environment(homeScreenRouter)
                                .onTapGesture {
                                    tabVisibilityControls.makeHidden()
                                    homeScreenRouter.navigate(to: .eventDetailView(event: event))
                                }
                        }
                    }
                    .listStyle(.plain)
                    .scrollIndicators(.hidden)
                    .refreshable {viewModel.refreshRegisteredEvents()}
                }
            }
            .toolbar {homeViewToolBar}
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
            .onChange(of: homeScreenRouter.navPath) {
                if homeScreenRouter.navPath.isEmpty {
                    tabVisibilityControls.makeVisible()
                }
            }
            .onChange(of: UserManager.shared.currentUser?.registeredEventsIds) {
                viewModel.refreshRegisteredEvents()
            }
            .onAppear {
                if !hasAppeared {
                    viewModel.refreshRegisteredEvents()
                    hasAppeared = true
                }
            }
        }
    }

    struct CustomEventCardView: View {
        let event: Event
        @State var showConfirmationDialog = false
        var body: some View {
            EventCardView(event: event)
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
            Image("NAMIHeaderLogo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
        }

        if UserManager.shared.userType == .admin {
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
            withAnimation {
                registeredEvents = events
            }
        }
    }
}

#Preview {
    HomeView()
        .environment(AuthenticationManager())
        .environment(TabsControl())
}
