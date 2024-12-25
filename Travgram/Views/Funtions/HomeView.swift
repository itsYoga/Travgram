//
//  HomeView.swift
//  Travgram
//
//  Created by Jesse Liang on 2024/12/24.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack {
            Text("Welcome to Travgram!")
                .font(.largeTitle)
                .padding()
            
            // 這裡可以放置您想在首頁顯示的內容，例如行程精選、最新動態等
            Spacer()
        }
        .navigationTitle("Home")
    }
}

#Preview {
    HomeView()
}
