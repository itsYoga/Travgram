//
//  MapView.swift
//  Travgram
//

import SwiftUI
import MapKit
import TipKit

struct MapView: View {
    @EnvironmentObject var userManager: UserManager
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
        span: MKCoordinateSpan(latitudeDelta: 50, longitudeDelta: 50)
    )
    @State private var selectedTrip: Trip?

    var body: some View {
        NavigationView {
            ZStack {
                // Background Image
                Image("background") // Replace with your background image name
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                    .opacity(0.5)

                // Main Content
                Map(coordinateRegion: $region, annotationItems: userManager.trips) { trip in
                    MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: trip.latitude ?? 0, longitude: trip.longitude ?? 0)) {
                        Button {
                            selectedTrip = trip
                        } label: {
                            VStack {
                                Image(systemName: "mappin.circle.fill")
                                    .foregroundColor(.red)
                                    .font(.title)
                                Text(trip.name)
                                    .font(.caption)
                                    .fontWeight(.bold)
                            }
                        }
                    }
                }
                .edgesIgnoringSafeArea(.all)
            }
            .sheet(item: $selectedTrip) { trip in
                TripPhotoView(trip: trip)
            }
        }
    }
}

struct TripPhotoView: View {
    let trip: Trip

    var body: some View {
        ZStack {

            VStack {
                // Trip Title
                Text(trip.name)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()

                // Conditional Photo Display
                if trip.photos.isEmpty {
                    Text("No Images Available")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 20) {
                            ForEach(trip.photos, id: \.self) { photoData in
                                if let image = UIImage(data: photoData) {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(maxWidth: .infinity, maxHeight: 300)
                                        .cornerRadius(10)
                                        .padding(.horizontal)
                                } else {
                                    Text("Invalid Image Data")
                                        .foregroundColor(.red)
                                        .padding()
                                }
                            }
                        }
                    }
                }

                Spacer()
            }
            .padding()
            .navigationTitle("Trip Photos")
        }
    }
}
