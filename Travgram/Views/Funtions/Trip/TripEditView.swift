//
//  TripEditView.swift
//  Travgram
//
//  Created by Jesse Liang on 2024/12/25.
//

import SwiftUI
import SwiftData

struct TripEditView: View {
    @EnvironmentObject var userManager: UserManager
    @Environment(\.dismiss) private var dismiss

    @Bindable var trip: Trip
    @State private var showPhotoPicker = false

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Edit Trip Details")) {
                    TextField("Trip Name", text: $trip.name)
                    DatePicker("Date and Time", selection: $trip.date, displayedComponents: [.date, .hourAndMinute])
                    Picker("Trip Type", selection: $trip.type) {
                        ForEach(TripType.allCases) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                }

                Section {
                    Button("Manage Photos") {
                        showPhotoPicker = true
                    }
                }
            }
            .navigationTitle("Edit Trip")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        userManager.saveChanges()
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showPhotoPicker) {
                TripPhotoPickerView(trip: trip)
            }
        }
    }
}
