//
//  Route.swift
//  Linkbus
//
//  Created by Michael Carroll on 8/23/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import SwiftUI
import CoreLocation

struct Route: Identifiable {
    let id: Int?
    let title: String?
    let times: [Time]?
    fileprivate var coordinates: Coordinates
    
    var locationCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: coordinates.latitude,
            longitude: coordinates.longitude)
    }
}

struct Coordinates: Hashable, Codable {
    var latitude: Double
    var longitude: Double
}
