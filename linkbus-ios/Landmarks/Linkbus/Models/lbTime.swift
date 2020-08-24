//
//  TimeData.swift
//  Linkbus
//
//  Created by Michael Carroll on 8/23/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import SwiftUI

struct lbTime: Decodable {
    var startDate: Date
    var endDate: Date
    var timeString: String
    var hasStart: BooleanLiteralType
    var lastBusClass: BooleanLiteralType
    var ss: BooleanLiteralType
}
