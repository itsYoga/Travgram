//
//  TripListView.swift
//  Travgram
//
//  Created by Jesse Liang on 2024/12/25.
//

import SwiftUI
import SwiftData
import Lottie
import TipKit

struct TripListView: View {
    @EnvironmentObject var userManager: UserManager
    @State private var isAddingNewTrip = false
    @State private var showAnimation = false // Controls animation visibility
    @State private var searchText = "" // For searchable feature

    var body: some View {
        NavigationView {
            ZStack {
                // Background image
                Image("background") // Replace with your image name
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                    .opacity(0.5)

                // Main content
                VStack {
                    Spacer(minLength: 30) // Add space above the list to move it lower
                    
                    if filteredTrips.isEmpty {
                        ContentUnavailableView(
                            "沒有符合的行程",
                            systemImage: "magnifyingglass"
                        )
                        .foregroundColor(.gray)
                        .padding()
                    } else {
                        List {
                            // Display filtered trips sorted by date
                            ForEach(filteredTrips.sorted(by: { $0.date < $1.date })) { trip in
                                NavigationLink(destination: TripEditView(trip: trip)) {
                                    TripRowView(trip: trip)
                                }
                            }
                            .onDelete(perform: deleteTrip)
                        }
                        .listRowBackground(Color.clear) // Make rows transparent
                        .scrollContentBackground(.hidden) // Hide default list background
                    }
                }

                // Lottie Animation Overlay
                if showAnimation {
                    LottieView(animationName: "MapAnimation", loopMode: .playOnce)
                        .frame(width: 50, height: 50)
                        .transition(.scale)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                withAnimation {
                                    showAnimation = false
                                }
                            }
                        }
                }
            }
            .searchable(text: $searchText, prompt: "搜尋行程")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        isAddingNewTrip = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $isAddingNewTrip) {
                TripAddView(onTripAdded: handleTripAdded)
            }
        }
    }

    // Filter trips based on search text
    private var filteredTrips: [Trip] {
        if searchText.isEmpty {
            return userManager.trips
        } else {
            return userManager.trips.filter { trip in
                trip.name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    private func deleteTrip(at offsets: IndexSet) {
        for index in offsets {
            let trip = userManager.trips[index]
            userManager.deleteTrip(trip)
        }
    }

    private func handleTripAdded() {
        withAnimation {
            showAnimation = true
        }
    }
}

struct TripRowView: View {
    let trip: Trip

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(trip.name)
                    .font(.headline)
                Text("\(trip.date.formatted(date: .abbreviated, time: .shortened))")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text("Budget: \(trip.budget, format: .currency(code: "USD"))")
                    .font(.caption)
                    .foregroundColor(.blue)
                Text("Expenses: \(trip.expenses, format: .currency(code: "USD"))")
                    .font(.caption)
                    .foregroundColor(.red)
            }
            Spacer()
            // Display the first photo if available, otherwise show the trip type
            if let photoData = trip.photos.first, let image = UIImage(data: photoData) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
            } else {
                Text(trip.type.rawValue)
                    .font(.caption)
                    .padding(6)
                    .background(Color.blue.opacity(0.2))
                    .cornerRadius(8)
            }
        }
    }
}
