//
//  ChatUnavailableView.swift
//  NAMI
//
//  Created by Sophie Zhuang on 1/2/25.
//
import SwiftUI
struct ChatUnavailableView: View {
    @Binding var isPresented: Bool // Binding to control visibility
    var body: some View {
        ZStack {
            // Background overlay
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    isPresented = false // Dismiss on tap outside
                }
            
            // Popup card with dark grey background
            VStack(alignment: .leading, spacing: 20) {
                // Title text
                Text("Oh no, you’re reaching NAMI’s helpline outside of office hours")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white) // White text color for dark mode
                    .multilineTextAlignment(.leading)
                
                // Body text
                Text("""
If you would prefer to call the helpline - 615-891-4724 (9a-5p M-F). If you are experiencing a mental health crisis during this time, please call 855-274-7471 OR Call/Text 988.
""")
                    .font(.system(size: 16))
                    .foregroundColor(.white) // White text color for dark mode
                    .multilineTextAlignment(.leading)
                    .lineSpacing(4)
                
                Spacer() // Spacer above the buttons
                
                // Buttons centered vertically
                HStack {
                    Spacer() // Push buttons to the right
                    Button(action: {
                        // Action 2 logic
                    }) {
                        Text("Action 2")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(Color.white) // Button color
                    }
                    
                    Button(action: {
                        // Action 1 logic
                    }) {
                        Text("Action 1")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(Color.white) // Button color
                            .padding(.leading, 10) // Add space between buttons
                    }
                }
                
                Spacer() // Spacer below the buttons
            }
            .padding(20)
            .background(Color.black) // Dark gray background for the popup card
            .cornerRadius(20)
            .frame(maxWidth: .infinity, maxHeight: 400) // Adjusted height for a taller card
            .padding(.horizontal, 20)
        }
    }
}
#Preview {
    ChatUnavailableView(isPresented: .constant(true))
}



