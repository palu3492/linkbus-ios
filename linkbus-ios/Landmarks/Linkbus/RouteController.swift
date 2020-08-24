//
//  NetworkController.swift
//  Linkbus
//
//  Created by Michael Carroll on 8/23/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import SwiftUI

class RouteController: ObservableObject {
    var apiRouteDetail: RouteDetail!
    @Published var apiBusSchedule = BusSchedule(msg: "", attention: "", routes: [Route]())
    
    @Published var lbBusSchedule: lbBusSchedule!
    
    init() {
        newWebRequest()
    }
}

extension RouteController {
    
    func webRequest() {
        // call CSBSJU API
        let networkController = NetworkController()
        networkController.loadCsbsjuApi() {
            api in
            self.apiBusSchedule = api
            print(self.apiBusSchedule.routes!.count)
        }
        //networkController.loadCsbsjuApi()
        //self.processJson()
    }
    
    func newWebRequest() {
        let url = URL(string: "https://apps.csbsju.edu/busschedule/api/?date=11/1/2019")!
        
        URLSession.shared.dataTask(with: url) {(data,response,error) in
            do {
                if let d = data {
                    let decodedLists = try JSONDecoder().decode(BusSchedule.self, from: d)
                    DispatchQueue.main.async {
                        self.apiBusSchedule = decodedLists
                        self.processJson()
                    }
                }else {
                    print("No Data")
                }
            } catch {
                print ("Error")
            }
            
        }.resume()
        
    }

func processJson() {
    //print(apiBusSchedule.routes?.count)
    //let busSchedule = BusSchedule(msg: apiBusSchedule.msg!, attention: apiBusSchedule.attention!, routes: apiBusSchedule.routes!)
    
    lbBusSchedule.msg = apiBusSchedule.msg!
    lbBusSchedule.attention = apiBusSchedule.attention!
    
    if !(apiBusSchedule.routes!.isEmpty) {
        for apiRoute in apiBusSchedule.routes! {
            var tempRoute: lbRoute!
            tempRoute.id = apiRoute.id!
            tempRoute.title = apiRoute.title!
            var tempTimes: [lbTime]!
            
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
                    
                    tempTimes.append(lbTime(startDate: startDate, endDate: endDate, timeString: timeString, hasStart: true, lastBusClass: apiTime.lbc!, ss: apiTime.ss!))
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
                    
                    tempTimes.append(lbTime(startDate: startDate, endDate: endDate, timeString: timeString, hasStart: false, lastBusClass: apiTime.lbc!, ss: apiTime.ss!))
                }
            }
            tempRoute.times = tempTimes
            
            // add in Linkbus API route data
            tempRoute.category = apiRouteDetail.category
            tempRoute.city = apiRouteDetail.city
            tempRoute.state = apiRouteDetail.state
            tempRoute.coordinates = apiRouteDetail.coordinates
            
            lbBusSchedule.routes.append(tempRoute)
        }
        
    }
    
    var iterator = lbBusSchedule.routes[0].times.makeIterator()
    while let time = iterator.next() {
        print(time.timeString)
    }
    
}
}

