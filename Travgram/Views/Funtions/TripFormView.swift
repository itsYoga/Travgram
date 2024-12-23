//
//  TripFormView.swift
//  Travgram
//
//  Created by Jesse Liang on 2024/12/24.
//

import SwiftUI
import SwiftData

struct TripFormView: View {
    @Environment(\.modelContext) private var context
    @EnvironmentObject var userManager: UserManager

    @Binding var trip: Trip?

    // Form properties
    @State private var name = ""
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var type = "Mountain"
    @State private var budget = 1000.0
    @State private var participants = 1
    @State private var color = "#FF5733"
    @State private var reminder = false
    @State private var notes = ""

    let tripTypes = ["Mountain", "Sea", "City", "Attraction"]

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Trip Details")) {
                    TextField("Trip Name", text: $name)
                    Picker("Type", selection: $type) {
                        ForEach(tripTypes, id: \.self) { type in
                            Text(type)
                        }
                    }
                    DatePicker("Start Date", selection: $startDate, displayedComponents: [.date])
                    DatePicker("End Date", selection: $endDate, displayedComponents: [.date])
                    TextField("Notes", text: $notes)
                }

                Section(header: Text("Settings")) {
                    ColorPicker("Label Color", selection: Binding(
                        get: { Color(hex: color) ?? .red },
                        set: { color = $0.toHex() }
                    ))
                    Slider(value: $budget, in: 0...10000, step: 100) {
                        Text("Budget")
                    }
                    Text("Budget: \(Int(budget))")
                    Stepper("Participants: \(participants)", value: $participants, in: 1...20)
                    Toggle("Reminder", isOn: $reminder)
                }
            }
            .navigationTitle(trip == nil ? "Add Trip" : "Edit Trip")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveTrip()
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        trip = nil
                    }
                }
            }
        }
        .onAppear {
            if let trip = trip {
                loadTrip(trip)
            }
        }
    }

    func loadTrip(_ trip: Trip) {
        name = trip.name
        startDate = trip.startDate
        endDate = trip.endDate
        type = trip.type
        budget = trip.budget
        participants = trip.participants
        color = trip.color
        reminder = trip.reminder
        notes = trip.notes ?? ""
    }

    func saveTrip() {
        guard let currentUser = userManager.currentUser else { return }
        
        if let trip = trip {
            // Update existing trip
            trip.name = name
            trip.startDate = startDate
            trip.endDate = endDate
            trip.type = type
            trip.budget = budget
            trip.participants = participants
            trip.color = color
            trip.reminder = reminder
            trip.notes = notes
        } else {
            // Create a new trip and assign the current user as the owner
            let newTrip = Trip(
                name: name,
                startDate: startDate,
                endDate: endDate,
                type: type,
                budget: budget,
                participants: participants,
                color: color,
                reminder: reminder,
                notes: notes,
                owner: currentUser
            )
            context.insert(newTrip)
        }

        do {
            try context.save()
        } catch {
            print("Failed to save trip: \(error)")
        }

        trip = nil // Dismiss the form
    }
}

#Preview {
    // Create a mock ModelContainer and environment
    let container = try! ModelContainer(for: User.self, Trip.self)
    let context = ModelContext(container)
    
    // Create a mock user for ownership
    let mockUser = User(username: "MockUser", email: "mock@example.com", password: "password")
    context.insert(mockUser)
    
    // Create a sample trip for testing "Edit Trip" functionality
    let sampleTrip = Trip(
        name: "Beach Vacation",
        startDate: Date(),
        endDate: Date().addingTimeInterval(86400), // +1 day
        type: "Sea",
        budget: 1500.0,
        participants: 4,
        color: "#00BFFF",
        reminder: true,
        notes: "Bring sunscreen!",
        owner: mockUser
    )
    context.insert(sampleTrip)
    
    // Mock UserManager with the current user set
    let mockUserManager = UserManager(context: context)
    mockUserManager.currentUser = mockUser

    return VStack {
        // Preview for "Add Trip" (no trip bound)
        TripFormView(trip: .constant(nil))
            .environmentObject(mockUserManager)
            .modelContainer(container)

        Divider()

        // Preview for "Edit Trip" (existing trip bound)
        TripFormView(trip: .constant(sampleTrip))
            .environmentObject(mockUserManager)
            .modelContainer(container)
    }
}
