//
//  NetworkController.swift
//  Linkbus
//
//  Created by Michael Carroll on 8/23/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import SwiftUI

class RouteController: ObservableObject {
    var apiRouteDetail: ApiRouteDetail!
    var apiBusSchedule: ApiBusSchedule!
    
    @Published var busSchedule: BusSchedule!
    
    init() {
        webRequest()
    }
}

extension RouteController {
    
    func webRequest() {
        // call CSBSJU API
        let networkController = NetworkController()
        networkController.loadLinkbusApi(completionHandler: {apiRouteDetail in
            self.apiRouteDetail = apiRouteDetail
            // call Linkbus API
            networkController.loadCsbsjuApi(completionHandler: {apiBusSchedule in
                self.apiBusSchedule = apiBusSchedule
                self.processJson()
            })
        })

    }
    
    func processJson() {
        //let busSchedule = BusSchedule(msg: apiBusSchedule.msg!, attention: apiBusSchedule.attention!, routes: apiBusSchedule.routes!)
        
        busSchedule.msg = apiBusSchedule.msg!
        busSchedule.attention = apiBusSchedule.attention!
        
        if !(apiBusSchedule.routes!.isEmpty) {
            for apiRoute in apiBusSchedule.routes! {
                var tempRoute: Route!
                tempRoute.id = apiRoute.id!
                tempRoute.title = apiRoute.title!
                var tempTimes: [Time]!
                
                for apiTime in apiRoute.times! {
                    
                    // process new time structure
                    if (apiTime.start != "") {
                        var isoDate = apiTime.start
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "MM/dd/yyyy h:mm:ss a"
                        dateFormatter.timeZone = TimeZone(identifier: "America/Central")
                        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
                        let startDate = dateFormatter.date(from:isoDate!)!
                        
                        isoDate = apiTime.end
                        let endDate = dateFormatter.date(from:isoDate!)!
                        
                        let textFormatter = DateFormatter()
                        textFormatter.dateFormat = "h:mm a"
                        
                        let timeString: String = (textFormatter.string(from: startDate) + " - " + (textFormatter.string(from: endDate)))
                        
                        tempTimes.append(Time(startDate: startDate, endDate: endDate, timeString: timeString, hasStart: true, lastBusClass: apiTime.lbc!, ss: apiTime.ss!))
                    }
                    else {
                        let isoDate = apiTime.end
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "MM/dd/yyyy h:mm:ss a"
                        dateFormatter.timeZone = TimeZone(identifier: "America/Central")
                        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
                        let endDate = dateFormatter.date(from:isoDate!)!
                        let startDate = endDate
                        
                        let textFormatter = DateFormatter()
                        textFormatter.dateFormat = "h:mm a"
                        
                        let timeString: String = (textFormatter.string(from: endDate))
                        
                        tempTimes.append(Time(startDate: startDate, endDate: endDate, timeString: timeString, hasStart: false, lastBusClass: apiTime.lbc!, ss: apiTime.ss!))
                    }
                }
                tempRoute.times = tempTimes
                
                // add in Linkbus API route data
                tempRoute.category = apiRouteDetail.category
                tempRoute.city = apiRouteDetail.city
                tempRoute.state = apiRouteDetail.state
                tempRoute.coordinates = apiRouteDetail.coordinates
                
                busSchedule.routes.append(tempRoute)
            }
            
        }
        
        var iterator = busSchedule.routes[0].times.makeIterator()
        while let time = iterator.next() {
            print(time.timeString)
        }

    }
}

