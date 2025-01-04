import PhotosUI
import SwiftUI
import SwiftData
import TipKit

struct EditProfileView: View {
    @Bindable var user: User
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context

    @State private var profileImage: UIImage?
    @State private var fullname: String = ""
    @State private var bio: String = ""
    @State private var selectedImage: PhotosPickerItem?

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Profile Picture")) {
                    VStack {
                        if let profileImage = profileImage {
                            Image(uiImage: profileImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 80, height: 80)
                                .clipShape(Circle())
                        } else {
                            Circle()
                                .fill(Color.gray)
                                .frame(width: 80, height: 80)
                                .overlay(
                                    Text("No Image")
                                        .foregroundColor(.white)
                                        .font(.caption)
                                )
                        }
                        PhotosPicker(selection: $selectedImage, matching: .images) {
                            Text("Choose Profile Picture")
                                .font(.footnote)
                                .foregroundColor(.blue)
                        }
                        .onChange(of: selectedImage) { newItem in
                            Task {
                                if let data = try? await newItem?.loadTransferable(type: Data.self),
                                   let uiImage = UIImage(data: data) {
                                    profileImage = uiImage
                                }
                            }
                        }
                        TipView(TipManager.shared.profilePictureTip) // Add profile picture tip
                    }
                }

                Section(header: Text("Full Name")) {
                    TextField("Full Name", text: $fullname)
                    TipView(TipManager.shared.fullNameTip) // Add full name tip
                }

                Section(header: Text("Bio")) {
                    TextField("Bio", text: $bio)
                    TipView(TipManager.shared.bioTip) // Add bio tip
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
        fullname = user.fullname ?? ""
        bio = user.bio ?? ""
        if let imageData = user.profileImageURL.flatMap({ Data(base64Encoded: $0) }) {
            profileImage = UIImage(data: imageData)
        }
    }

    private func saveChanges() {
        if let profileImage = profileImage,
           let imageData = profileImage.jpegData(compressionQuality: 0.8) {
            user.profileImageURL = imageData.base64EncodedString()
        }
        user.fullname = fullname.isEmpty ? nil : fullname
        user.bio = bio.isEmpty ? nil : bio

        do {
            try context.save()
        } catch {
            print("Failed to save profile changes: \(error)")
        }
    }
}
