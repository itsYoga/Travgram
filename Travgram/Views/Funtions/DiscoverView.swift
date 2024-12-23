//
//  DiscoverView.swift
//  Travgram
//
//  Created by Jesse Liang on 2024/12/24.
//

import SwiftUI

struct DiscoverView: View {
    var body: some View {
        VStack {
            Text("Discover New Places")
                .font(.title)
                .padding()
            
            // 可以在這裡放地圖、搜尋欄位、或推薦的景點清單
            Spacer()
        }
        .navigationTitle("Discover")
    }
}

#Preview {
    DiscoverView()
}
