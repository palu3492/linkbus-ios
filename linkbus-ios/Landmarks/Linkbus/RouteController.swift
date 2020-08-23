//
//  NetworkController.swift
//  Linkbus
//
//  Created by Michael Carroll on 8/23/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import SwiftUI

struct GoreckiToSexton {
    var routeData: [RouteData]
    var timeData: [TimeData]
}

struct SextonToGorecki {
    var routeData: [RouteData]
    var timeData: [TimeData]
}

struct CSBEast {
    var routeData: [RouteData]
    var timeData: [TimeData]
}

struct GoreckiToAlcuin {
    var routeData: [RouteData]
    var timeData: [TimeData]
}

struct AlcuinToGorecki {
    var routeData: [RouteData]
    var timeData: [TimeData]
}

class RouteController: ObservableObject {
}

extension RouteController {
    func processJson(apiBusSchedule: apiBusSchedule) {
        var goreckiToSexton: GoreckiToSexton = GoreckiToSexton(data: [apiRoute]())
        var sextonToGorecki: SextonToGorecki = SextonToGorecki(data: [Route]())
        var csbEast: CSBEast = CSBEast(data: [Route]())
        var goreckiToAlcuin: GoreckiToAlcuin = GoreckiToAlcuin(data: [Route]())
        var alcuinToGorecki: AlcuinToGorecki = AlcuinToGorecki(data: [Route]())
        
        // === GORECKI TO SEXTION ===
        if !(busSchedule.routes!.isEmpty) {
            var iterator = busSchedule.routes![0].times!.makeIterator()
            while let time = iterator.next() {
                if (time.start != "") {
                    var isoDate = time.start
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "MM/dd/yyyy h:mm:ss a"
                    dateFormatter.timeZone = TimeZone(identifier: "America/Central")
                    dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
                    let startDate = dateFormatter.date(from:isoDate!)!
                    
                    isoDate = time.end
                    let endDate = dateFormatter.date(from:isoDate!)!
                    
                    let textFormatter = DateFormatter()
                    textFormatter.dateFormat = "h:mm a"
                    
                    let timeString: String = (textFormatter.string(from: startDate) + " - " + (textFormatter.string(from: endDate)))
                    
                    let lbc = time.lbc
                    let ss = time.ss
                    
                    goreckiToSexton.data.append(RouteData(startDate: startDate, endDate: endDate, timeString: timeString, hasStart: true, lastBusClass: lbc!, ss: ss!))
                }
                else {
                    let isoDate = time.end
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "MM/dd/yyyy h:mm:ss a"
                    dateFormatter.timeZone = TimeZone(identifier: "America/Central")
                    dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
                    let endDate = dateFormatter.date(from:isoDate!)!
                    let startDate = endDate
                    
                    let textFormatter = DateFormatter()
                    textFormatter.dateFormat = "h:mm a"
                    
                    let timeString: String = (textFormatter.string(from: endDate))
                    
                    let lbc = time.lbc
                    let ss = time.ss
                    
                    goreckiToSexton.data.append(RouteData(startDate: startDate, endDate: endDate, timeString: timeString, hasStart: false, lastBusClass: lbc!, ss: ss!))
                }
            }
            
            //print(goreckiToSexton.data.description)
            
            var gtsIterator = goreckiToSexton.data.makeIterator()
            while let routeData = gtsIterator.next() {
                print(routeData.timeString)
            }
        }
    }
}

