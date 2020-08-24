//
//  BusSchedule.swift
//  Linkbus
//
//  Created by Michael Carroll on 8/23/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import SwiftUI

struct BusSchedule: Decodable {
    var msg: String
    var attention: String
    var routes: [Route]
}
