import SwiftUI
import TipKit

struct HomeView: View {
    @EnvironmentObject var userManager: UserManager // Access the current user

    let columns = [GridItem(.adaptive(minimum: 120), spacing: 10)]

    var body: some View {
        NavigationView {
            ZStack {
                // Background image
                Image("background") // Replace with your background image name
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                    .opacity(0.5)

                // Main content
                ScrollView {
                    VStack(spacing: 20) {
                        // Welcome Message
                        if let currentUser = userManager.currentUser {
                            Text("Welcome back, \(currentUser.username)!")
                                .font(.title)
                                .fontWeight(.semibold)
                                .padding(.top)
                                .cornerRadius(8)
                                .padding(.horizontal)
                        }

                        // Hero Section Text
                        VStack(spacing: 10) {
                            Text("Plan Your Next Adventure!")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.black)

                            Text("Discover places, track your trips, and share memories.")
                                .font(.subheadline)
                                .foregroundColor(.black)
                                .multilineTextAlignment(.center)
                        }
                        .padding()

                        // Features Grid
                        LazyVGrid(columns: columns, spacing: 10) {
                            FeatureIcon(title: "Trips", systemImage: "airplane")
                            FeatureIcon(title: "Photos", systemImage: "photo")
                            FeatureIcon(title: "Statistics", systemImage: "chart.pie")
                        }
                        .padding()
                    }
                }
                .scrollContentBackground(.hidden) // Hide default background
            }
        }
    }
}

struct FeatureIcon: View {
    let title: String
    let systemImage: String

    var body: some View {
        VStack {
            Image(systemName: systemImage)
                .resizable()
                .frame(width: 60, height: 60)
                .padding()
                .background(Color.blue.opacity(0.2))
                .clipShape(Circle())

            Text(title)
                .font(.caption)
                .fontWeight(.bold)
        }
    }
}
