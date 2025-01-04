//
//  SharedModels.swift
//  Travgram
//
//  Created by Jesse Liang on 2025/1/4.
//

import Foundation
import CoreLocation

struct MapAnnotationItem: Identifiable {
    let id: UUID
    var coordinate: CLLocationCoordinate2D
}
