//
//  TripListView.swift
//  Travgram
//
//  Created by Jesse Liang on 2024/12/25.
//

import SwiftUI
import SwiftData
import Lottie

struct TripListView: View {
    @EnvironmentObject var userManager: UserManager
    @State private var isAddingNewTrip = false
    @State private var showAnimation = false // Control animation visibility

    var body: some View {
        NavigationView {
            ZStack {
                List {
                    // 按日期排序的行程清單
                    ForEach(userManager.trips.sorted(by: { $0.date < $1.date })) { trip in
                        NavigationLink(destination: TripEditView(trip: trip)) {
                            TripRowView(trip: trip)
                        }
                    }
                    .onDelete(perform: deleteTrip)
                }
                .navigationTitle("行程計畫")
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
                Text("預算：\(trip.budget, format: .currency(code: "USD"))")
                    .font(.caption)
                    .foregroundColor(.blue)
                Text("花費：\(trip.expenses, format: .currency(code: "USD"))")
                    .font(.caption)
                    .foregroundColor(.red)
            }
            Spacer()
            // 如果有照片，顯示第一張，否則顯示類型
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
