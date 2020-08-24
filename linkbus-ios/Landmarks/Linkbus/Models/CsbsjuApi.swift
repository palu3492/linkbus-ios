/*
See LICENSE folder for this sample’s licensing information.

Structs for CSB/SJU API call
*/

import SwiftUI

struct BusSchedule: Decodable {
    let msg: String?
    let attention: String?
    let routes: [Route]?
}

struct Route: Identifiable, Decodable {
    let id: Int?
    let title: String?
    let times: [Time]?
}

struct Time: Decodable {
    let start: String?
    let end: String?
    let lbc: BooleanLiteralType?
    let ss: BooleanLiteralType?
}

// end of json structs
