//
//  TripPhotoPickerView.swift
//  Travgram
//
//  Created by Jesse Liang on 2024/12/25.
//

import SwiftUI
import PhotosUI
import SwiftData
import TipKit

struct TripPhotoPickerView: View {
    @Bindable var trip: Trip
    @State private var selectedPhotos: [PhotosPickerItem] = []
    @State private var images: [UIImage] = []

    var body: some View {
        VStack {
            // Photos Picker
            PhotosPicker(
                selection: $selectedPhotos,
                matching: .images,
                photoLibrary: .shared()
            ) {
                Label("Add Photos", systemImage: "photo.on.rectangle")
                    .font(.headline)
                    .padding()
                    .background(Color.blue.opacity(0.2))
                    .cornerRadius(8)
            }
            .onChange(of: selectedPhotos) { _ in
                loadSelectedPhotos()
            }

            // Display selected images in a grid
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
                    ForEach(images, id: \.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .overlay(
                                Button(action: {
                                    removeImage(image)
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.red)
                                }
                                .padding(5),
                                alignment: .topTrailing
                            )
                    }
                }
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Trip Photos")
    }

    private func loadSelectedPhotos() {
        Task {
            for item in selectedPhotos {
                if let data = try? await item.loadTransferable(type: Data.self),
                   let image = UIImage(data: data) {
                    images.append(image)
                    trip.photos.append(data) // Store the photo data in the Trip
                }
            }
        }
    }

    private func removeImage(_ image: UIImage) {
        if let index = images.firstIndex(of: image) {
            images.remove(at: index)
            trip.photos.remove(at: index) // Remove from the Trip photos array
        }
    }
}
