//
//  LinkbusApi.swift
//  Linkbus

//  Stucts for Linkbus API call
//
//  Created by Michael Carroll on 8/23/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import SwiftUI

struct LinkbusApi: Decodable {
    let alerts: [Alert]
    let routes: [RouteDetail]
}

struct Alert: Identifiable, Decodable {
    let id: Int
    let active: Bool
    let text: String
    let clickable: Bool
    let action: String
    let color: String
}

struct RouteDetail: Decodable {
    let title, origin, originLocation, destination, destinationLocation, city, state: String
    let id: Int
    let coordinates: Coordinates
}

struct Coordinates: Decodable {
    let longitude, latitude: Double
}
