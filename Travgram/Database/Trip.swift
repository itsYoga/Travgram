//
//  Trip.swift
//  Travgram
//
//  Created by Jesse Liang on 2024/12/25.
//

import Foundation
import SwiftData
import TipKit


@Model
class Trip {
    let id: String
    var name: String
    var date: Date
    var type: TripType
    var photos: [Data] // Store image data for photos
    var budget: Double
    var expenses: Double
    var latitude: Double? // 經度
    var longitude: Double? // 緯度
    var placeName: String? // 地點名稱

    init(
        id: String = UUID().uuidString,
        name: String,
        date: Date,
        type: TripType,
        photos: [Data] = [], // Initialize with an empty array
        budget: Double = 0.0,
        expenses: Double = 0.0,
        latitude: Double? = nil,
        longitude: Double? = nil,
        placeName: String? = nil
    ) {
        self.id = id
        self.name = name
        self.date = date
        self.type = type
        self.photos = photos
        self.budget = budget
        self.expenses = expenses
        self.latitude = latitude
        self.longitude = longitude
        self.placeName = placeName
    }
}

enum TripType: String, CaseIterable, Identifiable, Codable {
    case mountain = "Mountain"
    case sea = "Sea"
    case city = "City"
    case attraction = "Attraction"
    case nationalPark = "National Park"
    case cultural = "Cultural"
    case adventure = "Adventure"
    case romantic = "Romantic"
    case wildlife = "Wildlife"
    case historical = "Historical"
    case luxury = "Luxury"
    case beach = "Beach"
    case family = "Family"
    case business = "Business"

    var id: String { self.rawValue }
}
