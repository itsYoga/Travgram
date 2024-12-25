//
//  HomeView.swift
//  Travgram
//
//  Created by Jesse Liang on 2024/12/24.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var userManager: UserManager // Access the current user

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Welcome Message
                    if let currentUser = userManager.currentUser {
                        Text("Welcome back, \(currentUser.username)!")
                            .font(.title)
                            .fontWeight(.semibold)
                            .padding(.top)
                    }

                    // Hero Section with Image
                    ZStack {
                        Image("travel_hero") // Replace with your image name
                            .resizable()
                            .scaledToFill()
                            .frame(height: 250)
                            .clipped()

                        VStack {
                            Text("Plan Your Next Adventure!")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                                .shadow(radius: 10)

                            Text("Discover places, track your trips, and share memories.")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.9))
                        }
                        .padding(.top, 50)
                    }

                    // Icon Grid for Features
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 120))], spacing: 20) {
                        FeatureIcon(title: "Trips", systemImage: "airplane")
                        FeatureIcon(title: "Photos", systemImage: "photo")
                        FeatureIcon(title: "Statistics", systemImage: "chart.pie")
                        FeatureIcon(title: "Profile", systemImage: "person")
                    }
                    .padding()
                }
            }
            .navigationTitle("Home")
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


