//
//  HomeView.swift
//  NAMI
//
//  Created by Zachary Tao on 11/10/24.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack{
            VStack{
                Text("This is homeview")
            }
            .navigationTitle("Welcome")
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading){
                    Button{

                    } label: {
                        Image(systemName: "line.horizontal.3")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing){
                    Button{

                    } label: {
                        Image(systemName: "person.fill")
                    }
                }
            }
        }
    }
}


#Preview {
        HomeView()
        .tint(.primary)
}
