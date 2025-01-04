//
//  LocationHelpers.swift
//  Travgram
//
//  Created by Jesse Liang on 2024/12/25.
//

import CoreLocation

func reverseGeocode(latitude: Double, longitude: Double, completion: @escaping (String?) -> Void) {
    let location = CLLocation(latitude: latitude, longitude: longitude)
    CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
        if let place = placemarks?.first {
            completion(place.locality ?? place.name)
        } else {
            completion(nil)
        }
    }
}
