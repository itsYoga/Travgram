import SwiftUI
import SwiftData
import TipKit


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

                // Trips Tab
                TripListView()
                    .tabItem {
                        Label("Trips", systemImage: "airplane.circle.fill")
                    }
                
                // Map Tab
                MapView()
                    .tabItem {
                        Label("Map", systemImage: "map.fill")
                    }
                
                
                // Statistics Tab
                TripStatisticsView()
                    .tabItem {
                        Label("Statistics", systemImage: "chart.bar.fill")
                    }

                // Profile Tab with Logout
                ProfileView()
                    .tabItem {
                        Label("Profile", systemImage: "person.fill")
                    }
            }
            .navigationBarBackButtonHidden(true)
            .navigationTitle("Travgram")
        }
        .environmentObject(userManager)
    }
}


