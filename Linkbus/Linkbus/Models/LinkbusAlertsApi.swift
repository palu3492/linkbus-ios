//
//  LinkbusAlertsApi.swift
//  Linkbus
//
//  Created by Alex Palumbo on 10/24/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import SwiftUI

struct LinkbusAlertsApi: Decodable {
    let alerts: [NewAlert]
}

struct NewAlert: Identifiable, Decodable {
    let id: String
    let active: Bool
    let text: String
    let clickable: Bool
    let action: String
    let fullWidth: Bool
    let color: String
    let rgb: RGBColor
    let uid: Int
    let colorCode: String
}

