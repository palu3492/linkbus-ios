/*
See LICENSE folder for this sample’s licensing information.

Structs for CSB/SJU API call
*/

import SwiftUI

struct ApiBusSchedule: Decodable {
    let msg: String?
    let attention: String?
    let routes: [ApiRoute]?
}

struct ApiRoute: Decodable, Identifiable {
    let id: Int?
    let title: String?
    let times: [ApiTime]?
}

struct ApiTime: Decodable {
    let start: String?
    let end: String?
    let lbc: BooleanLiteralType?
    let ss: BooleanLiteralType?
}

// end of json structs
