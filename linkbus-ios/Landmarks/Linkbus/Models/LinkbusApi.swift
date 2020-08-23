//
//  LinkbusApi.swift
//  Linkbus

//  Stucts for Linkbus API call
//
//  Created by Michael Carroll on 8/23/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import SwiftUI

struct LinkbusApi: Codable {
    let name, category, city, state: String
    let id: Int
    let coordinates: Coordinates
}

struct Coordinates: Codable {
    let longitude, latitude: Double
}
