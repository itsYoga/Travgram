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
            .navigationBarBackButtonHidden(true)
            .navigationTitle("Travgram")
        }
        .environmentObject(userManager)
    }
}

#Preview {
    do {
        let container = try ModelContainer(for: User.self)
        let context = container.mainContext
        let mockUserManager = UserManager(context: context)

        mockUserManager.isLoggedIn = true

        return MainPageView()
            .environmentObject(mockUserManager)
    } catch {
        return Text("Error initializing preview")
    }
}
