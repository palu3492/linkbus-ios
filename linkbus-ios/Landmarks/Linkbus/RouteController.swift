//
//  NetworkController.swift
//  Linkbus
//
//  Created by Michael Carroll on 8/23/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import SwiftUI

class RouteController: ObservableObject {
    let CsbsjuApiUrl = "https://apps.csbsju.edu/busschedule/api/?date=9/1/2020"
    let LinkbusApiUrl = "https://raw.githubusercontent.com/michaelcarroll/linkbus-ios/master/linkbus-ios/Landmarks/Linkbus/Resources/LinkbusAPI.json"
    
    var apiBusSchedule = BusSchedule(msg: "", attention: "", routes: [Route]())
    var apiRouteDetail = [RouteDetail]()
    
    @Published var lbBusSchedule = LbBusSchedule(msg: "", attention: "", routes: [LbRoute]())
    
    init() {
        testLinkBusApi()
        webRequest()
    }
}

extension RouteController {
    
    func webRequest() {
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        fetchCsbsjuApi { apiResponse in
            if let success = apiResponse {
                DispatchQueue.main.async {
                    self.apiBusSchedule = apiResponse!
                    print(self.apiBusSchedule)
                    dispatchGroup.leave()
                }
            }
        }
        
        dispatchGroup.enter()
        fetchLinkbusApi { apiResponse in
            if let success = apiResponse {
                DispatchQueue.main.async {
                    self.apiRouteDetail = apiResponse!
                    print(self.apiRouteDetail)
                    dispatchGroup.leave()
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            self.processJson()
        }
    }
    
    func testLinkBusApi() {
        fetchLinkbusApi { apiResponse in
            if let success = apiResponse {
                    self.apiRouteDetail = apiResponse!
                    print(self.apiRouteDetail)
                }
            }
        }
    
    func fetchCsbsjuApi(completionHandler: @escaping (BusSchedule?) -> Void) {
        let url = URL(string: CsbsjuApiUrl)!
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if let error = error {
                print("Error with fetching bus schedule from CSBSJU API: \(error)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                    print("Error with the response, unexpected status code: \(response)")
                    return
            }
            
            if let data = data,
                let apiResponse = try? JSONDecoder().decode(BusSchedule.self, from: data) {
                completionHandler(apiResponse)
            }
        })
        task.resume()
    }
    
    func fetchLinkbusApi(completionHandler: @escaping ([RouteDetail]?) -> Void) {
        let url = URL(string: LinkbusApiUrl)!
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if let error = error {
                print("Error with fetching bus schedule from Linkbus API: \(error)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                    print("Error with the response, unexpected status code: \(response)")
                    return
            }
            
            if let data = data,
                let apiResponse = try? JSONDecoder().decode([RouteDetail].self, from: data) {
                completionHandler(apiResponse)
            }
        })
        task.resume()
    }
    
    func processJson() {
        //print(apiBusSchedule.routes?.count)
        //let busSchedule = BusSchedule(msg: apiBusSchedule.msg!, attention: apiBusSchedule.attention!, routes: apiBusSchedule.routes!)
        
        lbBusSchedule.msg = apiBusSchedule.msg!
        lbBusSchedule.attention = apiBusSchedule.attention!
        
        if !(apiBusSchedule.routes!.isEmpty) {
            for apiRoute in apiBusSchedule.routes! {
                var tempRoute = LbRoute(id: 0, title: "", times: [LbTime](), origin: "", originLocation: "", destination: "", destinationLocation: "", city: "", state: "", coordinates: Coordinates(longitude: 0, latitude: 0))
                tempRoute.id = apiRoute.id!
                tempRoute.title = apiRoute.title!
                var tempTimes = [LbTime]()
                
                var tempId = 0
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
                        
                        tempId+=1
                        tempTimes.append(LbTime(id: tempId, startDate: startDate, endDate: endDate, timeString: timeString, hasStart: true, lastBusClass: apiTime.lbc!, ss: apiTime.ss!))
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
                        
                        tempId+=1
                        tempTimes.append(LbTime(id: tempId, startDate: startDate, endDate: endDate, timeString: timeString, hasStart: false, lastBusClass: apiTime.lbc!, ss: apiTime.ss!))
                    }
                }
                tempRoute.times = tempTimes
                
                // TODO: add in Linkbus API route data
                let i = apiRouteDetail.firstIndex(where: {$0.id == tempRoute.id})
                tempRoute.origin = apiRouteDetail[i!].origin
                tempRoute.originLocation = apiRouteDetail[i!].originLocation
                tempRoute.destination = apiRouteDetail[i!].destination
                tempRoute.destinationLocation = apiRouteDetail[i!].destinationLocation
                tempRoute.city = apiRouteDetail[i!].city
                tempRoute.state = apiRouteDetail[i!].state
                tempRoute.coordinates = apiRouteDetail[i!].coordinates
                
                lbBusSchedule.routes.append(tempRoute)
            }
            
        }
        
        var iterator = lbBusSchedule.routes[0].times.makeIterator()
        while let time = iterator.next() {
            print(time.timeString)
        }
        
    }
}

