//
//  CustomSearchBar.swift
//  NAMI
//
//  Created by Zachary Tao on 11/17/24.
//

import SwiftUI

struct CustomSearchBar: View {
    @Binding var searchText: String
    @FocusState var keyboardIsPresent: Bool

    var body: some View {
        VStack {
            HStack(spacing: 5) {
                HStack(spacing: 12) {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(.gray)

                    TextField("Search for a quote...", text: $searchText)
                        .focused($keyboardIsPresent)
                }
                .padding()
                .frame(height: 45)
                .background {RoundedRectangle(cornerRadius: 20).fill(.ultraThinMaterial)}
                .overlay {
                    if !searchText.isEmpty {
                        Button("", systemImage: "multiply.circle.fill") {
                            searchText = ""
                        }
                        .foregroundStyle(.gray)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(5)

                    }
                }

                if keyboardIsPresent {
                    Button("Cancel") {
                        keyboardIsPresent = false
                        searchText = ""
                    }
                }
            }
            .frame(height: 45)
            .padding(.horizontal, 10)
            .transition(.move(edge: .trailing))
            .animation(.easeInOut(duration: 0.15), value: keyboardIsPresent)
        }
    }
}

