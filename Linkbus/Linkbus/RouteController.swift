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
    // Until we switch to new API, the user and branch need to change depending on current enviroment
    let LinkbusApiUrl = "https://raw.githubusercontent.com/michaelcarroll/linkbus-ios/dev/Linkbus/Linkbus/Resources/LinkbusAPI.json"
    // Using both APIs for now
    let LinkbusAlertsApiUrl = "https://us-central1-linkbus-website.cloudfunctions.net/api"
    
    var csbsjuApiResponse = BusSchedule(msg: "", attention: "", routes: [Route]())
    var linkbusApiResponse = LinkbusApi(routes: [RouteDetail]())
    var linkbusAlertsApiResponse = LinkbusAlertsApi(alerts: [NewAlert]())
    
    @Published var lbBusSchedule = LbBusSchedule(msg: "", attention: "", alerts: [NewAlert](), routes: [LbRoute]())
    @Published var refreshedLbBusSchedule = LbBusSchedule(msg: "", attention: "", alerts: [NewAlert](), routes: [LbRoute]())
    @Published var localizedDescription = ""
    @Published var onlineStatus = ""
    
    private var webRequestInProgress: Bool
    
    private var dailyMessage: String
    
    init() {
        self.dailyMessage = ""
        self.webRequestInProgress = false
        webRequest()
        
    }
}

extension RouteController {
    
    func webRequest() {

        if webRequestInProgress == false {
            webRequestInProgress = true
            self.localizedDescription = "default"
            
            csbsjuApiResponse = BusSchedule(msg: "", attention: "", routes: [Route]())
            linkbusApiResponse = LinkbusApi(routes: [RouteDetail]())
            refreshedLbBusSchedule = LbBusSchedule(msg: "", attention: "", alerts: [NewAlert](), routes: [LbRoute]())
            print("clear")
            linkbusAlertsApiResponse = LinkbusAlertsApi(alerts: [NewAlert]())
            
            let dispatchGroup = DispatchGroup()
            
            // CSBSJU API
            dispatchGroup.enter()
            fetchCsbsjuApi { apiResponse in
                if apiResponse != nil {
                    DispatchQueue.main.async {
                        self.csbsjuApiResponse = apiResponse!
                        dispatchGroup.leave()
                    }
                }
            }
            
            // Alert/route JSON data "API" from GitHub
            dispatchGroup.enter()
            fetchLinkbusApi { apiResponse in
                if apiResponse != nil {
                    DispatchQueue.main.async {
                        self.linkbusApiResponse = apiResponse!
                        dispatchGroup.leave()
                    }
                }
            }
            
            // Daily message alert
            dispatchGroup.enter()
            fetchDailyMessage { response in
                if response != nil {
                    DispatchQueue.main.async {
                        self.dailyMessage = response!
                        dispatchGroup.leave()
                    }

                }
                
            }
            
            // New API connected to website for alerts
            dispatchGroup.enter()
            fetchAlerts { apiResponse in
                if apiResponse != nil {
                    DispatchQueue.main.async {
                        self.linkbusAlertsApiResponse = apiResponse!
                        dispatchGroup.leave()
                    }
                }
            }
            
            dispatchGroup.notify(queue: .main) {
                self.processJson()
            }
        }
        
    }
    
    
    func fetchCsbsjuApi(completionHandler: @escaping (BusSchedule?) -> Void) {
        let url = URL(string: CsbsjuApiUrl)!
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if let error = error {
                DispatchQueue.main.async {
                    self.localizedDescription = error.localizedDescription
                    self.onlineStatus = "offline"
                    self.webRequestInProgress = false
                }
                //print("Error with fetching bus schedule from CSBSJU API: \(error)")
                return
            }
            else {
                DispatchQueue.main.async {
                    if self.onlineStatus == "offline" {
                        self.onlineStatus = "back online"
                    }
                    else if self.onlineStatus == "back online" {
                        self.onlineStatus = "online"
                    }
                        self.localizedDescription = "no error"
                    
                }
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                //print("Error with the response, unexpected status code: \(response)")
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
                //print("Error with fetching bus schedule from Linkbus API: \(error)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                //print("Error with the response, unexpected status code: \(response)")
                return
            }
            //print(httpResponse)
            
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
     - Parameter completionHandler: The callback function to be executed on successful fetching of website html.
     
     - Returns: calls completion handler with daily message as argument or returns nill on error.
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
        // However.. they've worked for a couple months so far.
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
                //print("Error with fetching daily message: \(error)")
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                //print("Error with the response, unexpected status code: \(String(describing: response))")
                return
            }
            // Process HTML into data we care about, the "daily message"
            let dailyMessage = self.processDailyMessage(data: data!)
            completionHandler(dailyMessage)
        })
        task.resume()
    }
    
    /**
     
     Processes the daily message website HTML into just the daily message string.
     - Parameter data: The fetched bus schedule website HTML.
     
     - Returns: Daily message string or empty string.
     */
    func processDailyMessage(data: Data) -> String {
        // Use regex to parse HTML for daily message within p tag
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
        // Return empty string if regex does not work
        return ""
    }
    
    /**
     Fetches the new Linkbus API json data. Currenly only alert data.
     - Parameter completionHandler: The callback function to be executed on successful fetching of API JOSN data.
     
     - Returns: calls completion handler with the API response as argument or returns nill on error.
     */
    func fetchAlerts(completionHandler: @escaping (LinkbusAlertsApi?) -> Void) {
        let url = URL(string: LinkbusAlertsApiUrl)!
        
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
               let apiResponse = try? JSONDecoder().decode(LinkbusAlertsApi.self, from: data) {
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
        
        // SKIPPING OLD ALERTS
        // TODO: Remove this later
        // only add active alerts to lbBusSchedule
        //        if !(linkbusApiResponse.alerts.isEmpty) {
        //            for apiAlert in linkbusApiResponse.alerts {
        //                if (apiAlert.active) {
        //                    lbBusSchedule.alerts.append(apiAlert)
        //                }
        //            }
        //        }
        // USING NEW ALERTS FROM API
        for apiAlert in linkbusAlertsApiResponse.alerts {
            if (apiAlert.active) {
                lbBusSchedule.alerts.append(apiAlert)
            }
        }
        // Create alert from daily message
        // Website will be able to customize this in the near future
        if self.dailyMessage != "" {
            // Only add to alerts if message is not empty string
            let color = RGBColor(red: 0.0, green: 0.0, blue: 0.0, opacity: 0.0)
            let dailyMessageAlert = NewAlert(id: "h213h408", active: true, text: self.dailyMessage,
                                             clickable: true, action: "", fullWidth: false,
                                             color: "blue", rgb: color, uid: 1, colorCode: "#000")
            lbBusSchedule.alerts.append(dailyMessageAlert)
        }
        
        for a in lbBusSchedule.alerts {
            print(a)
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
                        let isoStartDate = apiTime.start
                        let isoEndDate = apiTime.end
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "MM/dd/yyyy h:mm:ss a"
                        dateFormatter.timeZone = TimeZone(identifier: "America/Central")
                        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
                        let startDate = dateFormatter.date(from:isoStartDate!)!
                        let endDate = dateFormatter.date(from:isoEndDate!)!
                        
                        // current time - 1 min so that a bus at 5:30:00 still appears in app if currentTime is 5:30:01
                        let calendar = Calendar.current
                        let date = Date()
                        let currentDate = calendar.date(byAdding: .minute, value: -1, to: date)
                        if (endDate >= currentDate!) { // make sure end date is not in the past, if true skip add
                            
                            
                            // current time + 1 min so that a bus at 5:30:00 still appears in app if currentTime is 5:30:01
                            let calendar = Calendar.current
                            let date = Date()
                            let currentDate = calendar.date(byAdding: .minute, value: -1, to: date)
                            
                            if (startDate >= currentDate!) { // make sure start date is not in the past, if true skip add
                                
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
                        
                        // next bus timer logic:
                        
                        let nextBusStart = tempRoute.times[0].startDate
                        let nextBusEnd = tempRoute.times[0].endDate
                        
                        //https://stackoverflow.com/a/41640902
                        let formatter = DateComponentsFormatter()
                        formatter.unitsStyle = .full
                        formatter.allowedUnits = [.month, .day, .hour, .minute]
                        formatter.maximumUnitCount = 2   // often, you don't care about seconds if the elapsed time is in months, so you'll set max unit to whatever is appropriate in your case
                        let timeDifference = formatter.string(from: Date(), to: nextBusStart.addingTimeInterval(60))! //adds 60 seconds to round up
                        var nextBusTimer: String
                        
                        if (nextBusStart != nextBusEnd) && (Date() > nextBusStart) && (Date() < nextBusEnd) { // in a range
                            //                    if Date() >= nextBusEnd {
                            //                        nextBusTimer = "Departing now"
                            //                    }
                            //else {
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "h:mm a"
                            dateFormatter.timeZone = TimeZone(identifier: "America/Central")
                            dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
                            let nextBusTime = dateFormatter.string(from: nextBusEnd)
                            nextBusTimer = "Now until " + nextBusTime
                            //}
                        }
                        else if (timeDifference == "0 minutes" || Date() >= nextBusEnd) {
                            nextBusTimer = "Departing now"
                        }
                        else { // no range
                            nextBusTimer = timeDifference
                        }
                        tempRoute.nextBusTimer = nextBusTimer
                        
                    }
                }
                
                if (lbBusSchedule.routes.count > 0) {
                    var iterator = lbBusSchedule.routes[0].times.makeIterator()
                    while let time = iterator.next() {
                        print(time.timeString)
                    }
                }
                self.webRequestInProgress = false
            }
        }
    }
}
