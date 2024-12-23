//
//  MainPageView.swift
//  Travgram
//
//  Created by Jesse Liang on 2024/12/23.
//

import SwiftUI
import SwiftData

struct MainPageView: View {
    @EnvironmentObject var userManager: UserManager

    var body: some View {
        NavigationStack {
            TabView {
                // Home Tab
                HomeView()
                    .tabItem {
                        Label("Home", systemImage: "house.fill")
                    }
                
                // Trip List
                TripListView()
                    .tabItem {
                        Label("Trips", systemImage: "map")
                    }

                // Discover Tab
                DiscoverView()
                    .tabItem {
                        Label("Discover", systemImage: "magnifyingglass.circle.fill")
                    }

                // Profile Tab with Logout
                ProfileView()
                    .tabItem {
                        Label("Profile", systemImage: "person.fill")
                    }
            }
            .navigationBarBackButtonHidden(true) // Hide back button globally for root
            .navigationTitle("Travgram")       // Consistent title across tabs
        }
    }
}



#Preview {
    let container = try! ModelContainer(for: User.self)
    let context = ModelContext(container)
    let mockUserManager = UserManager(context: context)
    
    // Simulate a user being logged in:
    mockUserManager.isLoggedIn = true

    return MainPageView()
        .environmentObject(mockUserManager)
        .modelContainer(container)
}
