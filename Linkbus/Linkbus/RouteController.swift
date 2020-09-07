//
//  NetworkController.swift
//  Linkbus
//
//  Created by Michael Carroll on 8/23/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import SwiftUI

class RouteController: ObservableObject {
    let CsbsjuApiUrl = "https://apps.csbsju.edu/busschedule/api/"
    let LinkbusApiUrl = "https://raw.githubusercontent.com/michaelcarroll/linkbus-ios/master/linkbus-ios/Landmarks/Linkbus/Resources/LinkbusAPI.json"
    
    var csbsjuApiResponse = BusSchedule(msg: "", attention: "", routes: [Route]())
    var linkbusApiResponse = LinkbusApi(alerts: [Alert](), routes: [RouteDetail]())
    
    @Published var lbBusSchedule = LbBusSchedule(msg: "", attention: "", alerts: [Alert](), routes: [LbRoute]())
    
    init() {
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
                    self.csbsjuApiResponse = apiResponse!
                    print(self.csbsjuApiResponse)
                    dispatchGroup.leave()
                }
            }
        }
        
        dispatchGroup.enter()
        fetchLinkbusApi { apiResponse in
            if let success = apiResponse {
                DispatchQueue.main.async {
                    self.linkbusApiResponse = apiResponse!
                    print(self.linkbusApiResponse)
                    dispatchGroup.leave()
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            self.processJson()
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
    
    func fetchLinkbusApi(completionHandler: @escaping (LinkbusApi?) -> Void) {
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
                let apiResponse = try? JSONDecoder().decode(LinkbusApi.self, from: data) {
                completionHandler(apiResponse)
            }
        })
        task.resume()
    }
    
    func processJson() {
        //print(apiBusSchedule.routes?.count)
        //let busSchedule = BusSchedule(msg: apiBusSchedule.msg!, attention: apiBusSchedule.attention!, routes: apiBusSchedule.routes!)
        
        lbBusSchedule.msg = csbsjuApiResponse.msg!
        lbBusSchedule.attention = csbsjuApiResponse.attention!
        lbBusSchedule.alerts = linkbusApiResponse.alerts
        
        if !(csbsjuApiResponse.routes!.isEmpty) {
            for apiRoute in csbsjuApiResponse.routes! {
                var tempRoute = LbRoute(id: 0, title: "", times: [LbTime](), nextBusTimer: "", origin: "", originLocation: "", destination: "", destinationLocation: "", city: "", state: "", coordinates: Coordinates(longitude: 0, latitude: 0))
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
                        
                        if (startDate > Date()) { // make sure start date is not in the past, if true skip add
                            
                            isoDate = apiTime.end
                            let endDate = dateFormatter.date(from:isoDate!)!
                            
                            let textFormatter = DateFormatter()
                            textFormatter.dateFormat = "h:mm a"
                            
                            let timeString: String = (textFormatter.string(from: startDate) + " - " + (textFormatter.string(from: endDate)))
                            
                            tempId+=1
                            tempTimes.append(LbTime(id: tempId, startDate: startDate, endDate: endDate, timeString: timeString, hasStart: true, lastBusClass: apiTime.lbc!, ss: apiTime.ss!))
                        }
                    }
                    else {
                        let isoDate = apiTime.end
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "MM/dd/yyyy h:mm:ss a"
                        dateFormatter.timeZone = TimeZone(identifier: "America/Central")
                        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
                        let endDate = dateFormatter.date(from:isoDate!)!
                        let startDate = endDate
                        
                        if (startDate > Date()) { // make sure start date is not in the past, if true skip add
                            
                            let textFormatter = DateFormatter()
                            textFormatter.dateFormat = "h:mm a"
                            
                            let timeString: String = (textFormatter.string(from: endDate))
                            
                            
                            tempId+=1
                            tempTimes.append(LbTime(id: tempId, startDate: startDate, endDate: endDate, timeString: timeString, hasStart: false, lastBusClass: apiTime.lbc!, ss: apiTime.ss!))
                        }
                    }
                }
                
                if (tempTimes.count > 0) {
                    
                    tempRoute.times = tempTimes
                    
                    // TODO: add in Linkbus API route data
                    let i = linkbusApiResponse.routes.firstIndex(where: {$0.id == tempRoute.id})
                    tempRoute.origin = linkbusApiResponse.routes[i!].origin
                    tempRoute.originLocation = linkbusApiResponse.routes[i!].originLocation
                    tempRoute.destination = linkbusApiResponse.routes[i!].destination
                    tempRoute.destinationLocation = linkbusApiResponse.routes[i!].destinationLocation
                    tempRoute.city = linkbusApiResponse.routes[i!].city
                    tempRoute.state = linkbusApiResponse.routes[i!].state
                    tempRoute.coordinates = linkbusApiResponse.routes[i!].coordinates
                    
                    //https://stackoverflow.com/a/41640902
                    let formatter = DateComponentsFormatter()
                    formatter.unitsStyle = .full
                    formatter.allowedUnits = [.month, .day, .hour, .minute]
                    formatter.maximumUnitCount = 2   // often, you don't care about seconds if the elapsed time is in months, so you'll set max unit to whatever is appropriate in your case
                    var nextBusTimer = formatter.string(from: Date(), to: tempRoute.times[0].startDate.addingTimeInterval(60))! //adds 60 seconds to round up
                    
                    if (nextBusTimer == "0 minutes") {
                        nextBusTimer = "Departing now"
                    }
                    
                    tempRoute.nextBusTimer = nextBusTimer
                    
                    
                    lbBusSchedule.routes.append(tempRoute)
                }
                
            }
            
        }
        
        if (lbBusSchedule.routes.count > 0) {
            var iterator = lbBusSchedule.routes[0].times.makeIterator()
            while let time = iterator.next() {
                print(time.timeString)
            }
        }
        
    }
    
}


