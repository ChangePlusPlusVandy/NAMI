//
//  ChatView.swift
//  NAMI
//
//  Created by Zachary Tao on 11/10/24.
//

import SwiftUI

struct ChatView: View {
    let titleText = "NAMI HelpLine"
    let introText = "You are not alone! If you are struggling with your mental health, the NAMI HelpLine is here for you. Connect with a NAMI HelpLine volunteer today."
    let availabilityHours = "Monday Through Friday, 10 A.M. – 10 P.M. ET."
    
    var contactInfo: some View {
        Text("Call ")
        + Text("1-800-950-NAMI (6264)")
            .underline()
        + Text(", text \"HelpLine\" to ")
        + Text("62640")
            .underline()
        + Text(" or email us at ")
        + Text("helpline@nami.org")
            .underline()
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 30) {
                    Text(titleText)
                        .font(.largeTitle)
                         .padding(.top, 30)
                    
                    Text(introText)
                        .font(.body)
                        .foregroundStyle(.secondary)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Available:")
                            .font(.headline)
                        Text(availabilityHours)
                            .font(.body)
                            .foregroundStyle(.secondary)
                    }
                    
                    contactInfo
                        .font(.body)
                                        
                    Button {
                        
                    } label: {
                        Text("Start a Chat")
                            .padding(.horizontal, 10)
                            .padding()
                            .background(Color.NAMITealBlue)
                            .foregroundColor(.white)
                            .cornerRadius(25)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 60)

                }
                .padding(.horizontal)

            }
        }
    }
}

#Preview {
    ChatView()
}
