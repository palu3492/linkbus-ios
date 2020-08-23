/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The model for an individual landmark.
*/

import SwiftUI

struct ApiBusSchedule: Decodable {
    let msg: String?
    let attention: String?
    let routes: [Route]?
}

struct ApiRoute: Decodable, Identifiable {
    let id: Int?
    let title: String?
    let times: [Time]?
}

struct ApiTime: Decodable {
    let start: String?
    let end: String?
    let lbc: BooleanLiteralType?
    let ss: BooleanLiteralType?
}

// end of json structs
