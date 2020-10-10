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
    let LinkbusApiUrl = "https://raw.githubusercontent.com/michaelcarroll/linkbus-ios/master/Linkbus/Linkbus/Resources/LinkbusAPI.json"
    
    var csbsjuApiResponse = BusSchedule(msg: "", attention: "", routes: [Route]())
    var linkbusApiResponse = LinkbusApi(alerts: [Alert](), routes: [RouteDetail]())
    
    @Published var lbBusSchedule = LbBusSchedule(msg: "", attention: "", alerts: [Alert](), routes: [LbRoute]())
    
    private var dailyMessage: String
    
    init() {
        self.dailyMessage = ""
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
                    dispatchGroup.leave()
                }
            }
        }
        
        dispatchGroup.enter()
        fetchLinkbusApi { apiResponse in
            if let success = apiResponse {
                DispatchQueue.main.async {
                    self.linkbusApiResponse = apiResponse!
                    dispatchGroup.leave()
                }
            }
        }
        
        dispatchGroup.enter()
        fetchDailyMessage { response in
            if let success = response {
                DispatchQueue.main.async {
                    self.dailyMessage = response!
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
    
    /**
        Fetches the bus schedule website html that contains the daily message, seen here  https://apps.csbsju.edu/busschedule/
        After fetching the data, processDailyMessage() is called to grok the data into just the daily message string.
        - Parameter completionHandler: The callback function to be executed on success fetching of website html.
     
        - Returns: calls completion handler with daily message as argument or returns null on error.
     */
    func fetchDailyMessage(completionHandler: @escaping (String?) -> Void) {
        let url = URL(string: "https://apps.csbsju.edu/busschedule/default.aspx")
        // Create request
        var request = URLRequest(url: url!)
        // Set http method
        request.httpMethod = "POST"
        // Add body (form data)
        var postString = ""
        // These asp.net fields may not work forever!
        // However.. it's worked for a month so far.
        let specifyData = false
        if specifyData {
            // Allows for date to be changed. Disabled by default. Implement later.
            let date = "9/20/2020"
            let dateEncoded = date.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
            postString += "ctl00%24BodyContent%24BusSchedule%24SelectedDate=" + dateEncoded!
        }
        postString += "&__VIEWSTATE=%2FwEPDwUJMjUxNjA1NzE0ZBgGBUpjdGwwMCRCb2R5Q29udGVudCRCdXNTY2hlZHVsZSRSZXBlYXRlclRvZGF5Um91dGVzJGN0bDAyJEdyaWRWaWV3VG9kYXlUaW1lcw88KwAMAQgCAWQFSmN0bDAwJEJvZHlDb250ZW50JEJ1c1NjaGVkdWxlJFJlcGVhdGVyVG9kYXlSb3V0ZXMkY3RsMDQkR3JpZFZpZXdUb2RheVRpbWVzDzwrAAwBCAIBZAVKY3RsMDAkQm9keUNvbnRlbnQkQnVzU2NoZWR1bGUkUmVwZWF0ZXJUb2RheVJvdXRlcyRjdGwwMSRHcmlkVmlld1RvZGF5VGltZXMPPCsADAEIAgFkBUpjdGwwMCRCb2R5Q29udGVudCRCdXNTY2hlZHVsZSRSZXBlYXRlclRvZGF5Um91dGVzJGN0bDAzJEdyaWRWaWV3VG9kYXlUaW1lcw88KwAMAQgCAWQFSmN0bDAwJEJvZHlDb250ZW50JEJ1c1NjaGVkdWxlJFJlcGVhdGVyVG9kYXlSb3V0ZXMkY3RsMDAkR3JpZFZpZXdUb2RheVRpbWVzDzwrAAwBCAIBZAVKY3RsMDAkQm9keUNvbnRlbnQkQnVzU2NoZWR1bGUkUmVwZWF0ZXJUb2RheVJvdXRlcyRjdGwwNSRHcmlkVmlld1RvZGF5VGltZXMPPCsADAEIAgFkWGh%2B6w%2BaUlr4YOYVCBNBCh%2FBBLI%3D"
        postString += "&__VIEWSTATEGENERATOR=9BAD42EF"
        postString += "&__EVENTVALIDATION=%2FwEdAAJuu0YtVtaTDWfPQnmvmzb0LRHL%2FnpThEIWeX7N%2BkLIDZtqPuTRCdRUPrjcObmvVnKFIOev"
        postString += "&__ASYNCPOST=true"
        request.httpBody = postString.data(using: .utf8)
        // Add headers
        request.setValue("Delta=true", forHTTPHeaderField: "X-MicrosoftAjax")
        request.setValue("XMLHttpRequest", forHTTPHeaderField: "X-Requested-With")
        request.setValue("Mozilla/5.0 (Android 8.0)", forHTTPHeaderField: "User-Agent")
        // Create url session to send request
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            if let error = error {
                print("Error with fetching daily message: \(error)")
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                    print("Error with the response, unexpected status code: \(String(describing: response))")
                    return
            }
            let dailyMessage = self.processDailyMessage(data: data!)
            completionHandler(dailyMessage)
        })
        task.resume()
    }
    
    /**
        Processes the daily message website html into just the daily message string.
        - Parameter data: The fetched bus schedule website html.
     
        - Returns: Daily message string or empty string.
     */
    func processDailyMessage(data: Data) -> String {
        let dataString = String(decoding: data, as: UTF8.self)
        let pattern = #"TodayMsg"><p>([^<]*)<\/p>"#
        let regex = try? NSRegularExpression(pattern: pattern)
        let searchRange = NSRange(location: 0, length: dataString.utf16.count)
        if let match = regex?.firstMatch(in: dataString, options: [], range: searchRange) {
            if let secondRange = Range(match.range(at: 1), in: dataString) {
                let dailyMessage = String(dataString[secondRange])
                return dailyMessage
            }
        }
        return ""
    }
    
    func processJson() {
        //print(apiBusSchedule.routes?.count)
        //let busSchedule = BusSchedule(msg: apiBusSchedule.msg!, attention: apiBusSchedule.attention!, routes: apiBusSchedule.routes!)
        
        lbBusSchedule.msg = csbsjuApiResponse.msg!
        lbBusSchedule.attention = csbsjuApiResponse.attention!
        
        // only add active alerts to lbBusSchedule
        if !(linkbusApiResponse.alerts.isEmpty) {
            for apiAlert in linkbusApiResponse.alerts {
                if (apiAlert.active) {
                    lbBusSchedule.alerts.append(apiAlert)
                }
            }
        }
        // Create alert from daily message
        if self.dailyMessage != "" {
            // Only add to alerts if message is not empty string
            let color = RGBColor(red: 0.0, green: 0.0, blue: 0.0, opacity: 0.0)
            let dailyMessageAlert = Alert(id: 120, active: true, text: self.dailyMessage, clickable: true, action: "", fullWidth: false, color: "blue", rgb: color)
            lbBusSchedule.alerts.append(dailyMessageAlert)
        }
        
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
        
//        if (lbBusSchedule.routes.count > 0) {
//            var iterator = lbBusSchedule.routes[0].times.makeIterator()
//            while let time = iterator.next() {
//                print(time.timeString)
//            }
//        }
        
    }
    
}


