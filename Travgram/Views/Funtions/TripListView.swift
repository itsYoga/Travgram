//
//  TripListView.swift
//  Travgram
//
//  Created by Jesse Liang on 2024/12/24.
//

import SwiftUI
import SwiftData

struct TripListView: View {
    @Environment(\.modelContext) private var context
    @EnvironmentObject var userManager: UserManager

    @Query(sort: \Trip.startDate) private var allTrips: [Trip] // Fetch all trips
    @State private var filteredTrips: [Trip] = []              // Store filtered trips dynamically

    @State private var isPresentingTripForm = false
    @State private var selectedTrip: Trip?

    var body: some View {
        NavigationStack {
            List {
                ForEach(filteredTrips) { trip in
                    Button {
                        selectedTrip = trip
                        isPresentingTripForm = true
                    } label: {
                        HStack {
                            Circle()
                                .fill(Color(hex: trip.color)!)
                                .frame(width: 10, height: 10)
                            Text(trip.name)
                        }
                    }
                }
                .onDelete(perform: deleteTrips)
            }
            .navigationTitle("My Trips")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        selectedTrip = nil
                        isPresentingTripForm = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $isPresentingTripForm) {
                TripFormView(trip: $selectedTrip)
                    .environment(\.modelContext, context)
            }
            .onAppear {
                filterTrips()
            }
        }
    }

    // Filter trips for the current user
    private func filterTrips() {
        guard let currentUserID = userManager.currentUser?.id else {
            filteredTrips = []
            return
        }
        filteredTrips = allTrips.filter { $0.owner.id == currentUserID }
    }

    // Delete selected trips and refresh the filtered list
    private func deleteTrips(at offsets: IndexSet) {
        for index in offsets {
            context.delete(filteredTrips[index])
        }
        do {
            try context.save()
            filterTrips() // Refresh the filtered list
        } catch {
            print("Failed to delete trips: \(error)")
        }
    }
}


#Preview {
    // Create a mock ModelContainer and context
    let container = try! ModelContainer(for: User.self, Trip.self)
    let context = ModelContext(container)

    // Create a mock user
    let mockUser = User(username: "MockUser", email: "mock@example.com", password: "password")
    context.insert(mockUser)

    // Create some mock trips owned by the user
    let mockTrips = [
        Trip(name: "Beach Vacation", startDate: Date(), endDate: Date().addingTimeInterval(86400), type: "Sea", budget: 1500.0, participants: 4, color: "#00BFFF", reminder: true, notes: "Bring sunscreen!", owner: mockUser),
        Trip(name: "Mountain Hike", startDate: Date().addingTimeInterval(172800), endDate: Date().addingTimeInterval(259200), type: "Mountain", budget: 500.0, participants: 2, color: "#FF5733", reminder: false, notes: "Pack hiking boots!", owner: mockUser)
    ]
    mockTrips.forEach { context.insert($0) }

    // Set up a mock UserManager
    let mockUserManager = UserManager(context: context)
    mockUserManager.currentUser = mockUser

    return TripListView()
        .environmentObject(mockUserManager)
        .modelContainer(container)
}
