//
//  TripStatisticsView.swift
//  Travgram
//
//  Created by Jesse Liang on 2024/12/25.
//

import SwiftUI
import SwiftData
import Charts

struct TripStatisticsView: View {
    @EnvironmentObject var userManager: UserManager

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Budget and Expenses Bar Chart
                    VStack(alignment: .leading) {
                        Text("行程預算與花費統計")
                            .font(.headline)
                            .padding(.leading)

                        Chart {
                            ForEach(userManager.trips) { trip in
                                BarMark(
                                    x: .value("Trip", trip.name),
                                    y: .value("Budget", trip.budget)
                                )
                                .foregroundStyle(.blue)

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
                        Text("行程類型分布")
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
            .navigationTitle("行程統計")
        }
    }

    private func tripTypeDistribution() -> [TripTypeData] {
        var distribution: [TripType: Int] = [:]

        for trip in userManager.trips {
            distribution[trip.type, default: 0] += 1
        }

        return distribution.map { TripTypeData(type: $0.key, count: $0.value) }
    }
}

struct TripTypeData {
    let type: TripType
    let count: Int
}
