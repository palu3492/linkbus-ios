//
//  BusSchedule.swift
//  Linkbus
//
//  Created by Michael Carroll on 8/23/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import SwiftUI

struct BusSchedule: Decodable {
    let msg: String?
    let attention: String?
    let routes: [Route]?
}
