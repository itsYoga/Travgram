//
//  TripStatisticsView.swift
//  Travgram
//
//  Created by Jesse Liang on 2024/12/25.
//

import SwiftUI
import SwiftData
import Charts
import TipKit

struct TripStatisticsView: View {
    @EnvironmentObject var userManager: UserManager

    var body: some View {
        NavigationView {
            ZStack {
                // Background Image
                Image("profile") // Replace with your image name
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                    .opacity(0.5)

                // Main Content
                ScrollView {
                    VStack(spacing: 24) {
                        // Budget and Expenses Bar Chart
                        Spacer().frame(height: 70) // Adjust the height to move the content lower
                        VStack(alignment: .leading) {
                            Text("Trip Budget and Expenses Statistics")
                                .font(.headline)
                                .padding(.leading)

                            Chart {
                                ForEach(userManager.trips) { trip in
                                    // Bar for Budget
                                    BarMark(
                                        x: .value("Trip", trip.name),
                                        y: .value("Budget", trip.budget)
                                    )
                                    .foregroundStyle(.blue)

                                    // Bar for Expenses
                                    BarMark(
                                        x: .value("Trip", trip.name),
                                        y: .value("Expenses", trip.expenses)
                                    )
                                    .foregroundStyle(.red)
                                }
                            }
                            .frame(height: 200)
                        }

                        // Trip Type Distribution Pie Chart
                        VStack(alignment: .leading) {
                            Text("Trip Type Distribution")
                                .font(.headline)
                                .padding(.leading)

                            Chart {
                                ForEach(tripTypeDistribution(), id: \.type) { data in
                                    SectorMark(
                                        angle: .value("Count", data.count),
                                        innerRadius: .ratio(0.5),
                                        outerRadius: .ratio(1.0)
                                    )
                                    .foregroundStyle(by: .value("Type", data.type.rawValue))
                                }
                            }
                            .frame(height: 200)
                        }
                    }
                    .padding()
                }
            }
        }
    }

    // Calculate the distribution of trip types
    private func tripTypeDistribution() -> [TripTypeData] {
        var distribution: [TripType: Int] = [:]

        // Count the number of trips for each type
        for trip in userManager.trips {
            distribution[trip.type, default: 0] += 1
        }

        // Convert the dictionary into an array of TripTypeData
        return distribution.map { TripTypeData(type: $0.key, count: $0.value) }
    }
}

// Data model for trip type statistics
struct TripTypeData {
    let type: TripType
    let count: Int
}
