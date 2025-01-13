//
//  ChatUnavailableView.swift
//  NAMI
//
//  Created by Sophie Zhuang on 1/2/25.
//
import SwiftUI
struct ChatUnavailableView: View {
    @Binding var isPresented: Bool
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    withAnimation(.snappy) { isPresented.toggle() }
                }

            VStack(spacing: 40) {
                VStack(alignment: .leading, spacing: 15) {
                    Text("Oh no, you’re reaching NAMI’s helpline outside of office hours")
                        .font(.title3)
                        .bold()

                    Text("""
If you would prefer to call the helpline - 615-891-4724 (9a-5p M-F). If you are experiencing a mental health crisis during this time, please call 855-274-7471 OR Call/Text 988.
""")
                }
                .font(.headline)

                Button {
                    withAnimation (.snappy) { isPresented.toggle() }
                } label: {
                    Text("Dismiss")
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color.NAMIDarkBlue)
                        .foregroundColor(.white)
                        .cornerRadius(15)
                }
            }
            .padding(20)
            .background(colorScheme == .dark ? Color(.systemGray5) : Color.white)
            .cornerRadius(20)
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity, maxHeight: 400)
        }
    }
}
#Preview {
    ChatUnavailableView(isPresented: .constant(true))
}



