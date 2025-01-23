//
//  EventRegisteredSuccessSheet.swift
//  NAMI
//
//  Created by Zachary Tao on 1/23/25.
//

import SwiftUI

struct EventRegisteredSuccessSheet: View {
    @Binding var isPresented: Bool
    @Environment(\.colorScheme) var colorScheme
    @Environment(EventsViewRouter.self) var eventsViewRouter

    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 40) {
                VStack(alignment: .leading, spacing: 30) {
                    Text("Registration Complete")
                        .font(.title)
                        .foregroundStyle(Color.NAMIDarkBlue)

                        Text("You can find the meeting time, location, and any details you might need from the home page.")
                            .font(.callout)
                }

                Button {
                    eventsViewRouter.navigateToRoot()
                } label: {
                    Text("Dismiss")
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color.NAMIDarkBlue)
                        .foregroundColor(.white)
                        .cornerRadius(15)
                }
            }
            .padding(.vertical, 25)
            .padding(.horizontal, 25)
            .background(colorScheme == .dark ? Color(.systemGray5) : Color.white)
            .cornerRadius(20)
            .padding(.horizontal, 50)
            .frame(maxWidth: .infinity, maxHeight: 400)
        }
    }
}

#Preview {
    EventRegisteredSuccessSheet(isPresented: .constant(true))
        .environment(EventsViewRouter())
}
