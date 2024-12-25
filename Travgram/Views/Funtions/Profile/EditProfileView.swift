//
//  EditProfileView.swift
//  Travgram
//
//  Created by Jesse Liang on 2024/12/24.
//

import SwiftUI
import SwiftData

struct EditProfileView: View {
    @Bindable var user: User
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context

    @State private var profileImageURL: String = ""
    @State private var fullname: String = ""
    @State private var bio: String = ""

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Profile Picture")) {
                    TextField("Profile Image URL", text: $profileImageURL)
                }

                Section(header: Text("Full Name")) {
                    TextField("Full Name", text: $fullname)
                }

                Section(header: Text("Bio")) {
                    TextField("Bio", text: $bio)
                }
            }
            .navigationTitle("Edit Profile")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveChanges()
                        dismiss()
                    }
                }
            }
            .onAppear {
                loadProfileData()
            }
        }
    }

    private func loadProfileData() {
        profileImageURL = user.profileImageURL ?? ""
        fullname = user.fullname ?? ""
        bio = user.bio ?? ""
    }

    private func saveChanges() {
        user.profileImageURL = profileImageURL.isEmpty ? nil : profileImageURL
        user.fullname = fullname.isEmpty ? nil : fullname
        user.bio = bio.isEmpty ? nil : bio

        do {
            try context.save()
        } catch {
            print("Failed to save profile changes: \(error)")
        }
    }
}
