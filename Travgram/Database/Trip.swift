//
//  Trip.swift
//  Travgram
//
//  Created by Jesse Liang on 2024/12/24.
//

import Foundation
import SwiftData

@Model
class Trip {
    let id: String
    var name: String
    var startDate: Date
    var endDate: Date
    var type: String
    var budget: Double
    var participants: Int
    var color: String
    var reminder: Bool
    var notes: String?

    // Relationship to User
    @Relationship(deleteRule: .cascade) var owner: User

    init(
        id: String = UUID().uuidString,
        name: String,
        startDate: Date,
        endDate: Date,
        type: String,
        budget: Double,
        participants: Int,
        color: String,
        reminder: Bool,
        notes: String? = nil,
        owner: User
    ) {
        self.id = id
        self.name = name
        self.startDate = startDate
        self.endDate = endDate
        self.type = type
        self.budget = budget
        self.participants = participants
        self.color = color
        self.reminder = reminder
        self.notes = notes
        self.owner = owner
    }
}
