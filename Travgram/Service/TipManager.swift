//
//  TipManager.swift
//  Travgram
//
//  Created by Jesse Liang on 2025/1/4.
//

import Foundation
import TipKit

struct TipManager {
    // Singleton pattern
    static let shared = TipManager()

    // Centralized management of all tips
    let tripNameTip = TripNameTip()
    let budgetTip = BudgetTip()
    let locationTip = LocationTip()
    let photoTip = PhotoTip()
    let profilePictureTip = ProfilePictureTip()
    let fullNameTip = FullNameTip()
    let bioTip = BioTip()
    
    // Method to configure tips
    func configureTips() {
        do {
            try Tips.configure([
                .displayFrequency(.hourly), // Tip display frequency
                .datastoreLocation(.applicationDefault) // Default datastore location
            ])
        } catch {
            print("TipKit configuration failed: \(error.localizedDescription)")
        }
    }
}

// Tip for trip name
struct TripNameTip: Tip {
    
    var title: Text {
        Text("Trip Name")
    }
    
    var message: Text? {
        Text("Please enter a clear trip name for easier reference later.")
    }
    
    var image: Image? {
        Image(systemName: "pencil")
    }
    
    
}

// Tip for budget
struct BudgetTip: Tip {
    var title: Text {
        Text("Set Budget")
    }
    
    var message: Text? {
        Text("Use the slider to set your trip budget and choose a different currency.")
    }
    
    var image: Image? {
        Image(systemName: "dollarsign.circle")
    }
}

struct LocationTip: Tip {
    var title: Text {
        Text("Select Location")
    }
    
    var message: Text? {
        Text("Use the map to pinpoint your desired location or search for an address.")
    }
    
    var image: Image? {
        Image(systemName: "mappin.and.ellipse")
    }
}

struct PhotoTip: Tip {
    var title: Text {
        Text("Manage Photos")
    }
    
    var message: Text? {
        Text("Add, view, or remove photos to make your trip memories more vivid.")
    }
    
    var image: Image? {
        Image(systemName: "photo.on.rectangle.angled")
    }
}

struct ProfilePictureTip: Tip {
    var title: Text {
        Text("Profile Picture")
    }
    
    var message: Text? {
        Text("Upload a clear and recognizable profile picture to make your profile stand out.")
    }
    
    var image: Image? {
        Image(systemName: "person.crop.circle.badge.plus")
    }
}

struct FullNameTip: Tip {
    var title: Text {
        Text("Full Name")
    }
    
    var message: Text? {
        Text("Use your full name so others can easily identify you.")
    }
    
    var image: Image? {
        Image(systemName: "person.fill")
    }
}

struct BioTip: Tip {
    var title: Text {
        Text("Bio")
    }
    
    var message: Text? {
        Text("Add a short bio to let others know more about you.")
    }
    
    var image: Image? {
        Image(systemName: "text.alignleft")
    }
}
