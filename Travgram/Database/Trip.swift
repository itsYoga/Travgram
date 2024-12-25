//
//  Trip.swift
//  Travgram
//
//  Created by Jesse Liang on 2024/12/25.
//

import Foundation
import SwiftData

@Model
class Trip {
    let id: String
    var name: String
    var date: Date
    var type: TripType
    var photos: [Data] // Store image data for photos
    var budget: Double
    var expenses: Double

    init(
        id: String = UUID().uuidString,
        name: String,
        date: Date,
        type: TripType,
        photos: [Data] = [], // Initialize with an empty array
        budget: Double = 0.0,
        expenses: Double = 0.0
    ) {
        self.id = id
        self.name = name
        self.date = date
        self.type = type
        self.photos = photos
        self.budget = budget
        self.expenses = expenses
    }
}

enum TripType: String, CaseIterable, Identifiable, Codable {
    case mountain = "Mountain"
    case sea = "Sea"
    case city = "City"
    case attraction = "Attraction"

    var id: String { self.rawValue }
}
