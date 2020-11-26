//
//  NetworkController.swift
//  Linkbus
//
//  Created by Michael Carroll on 8/23/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import SwiftUI

class RouteController: ObservableObject {
    let CsbsjuApiUrl = "https://apps.csbsju.edu/busschedule/api" // /?date=11/23/2020
//    let LinkbusApiUrl = "https://us-central1-linkbus-website.cloudfunctions.net/api" // Production API
    let LinkbusApiUrl = "https://us-central1-linkbus-website-development.cloudfunctions.net/api" // Development API
    
    var csbsjuApiResponse = BusSchedule(msg: "", attention: "", routes: [Route]())
    var linkbusApiResponse = LinkbusApi(alerts: [Alert](), routes: [RouteDetail](), dailyMessage: DailyMessageSettings(id: "321", active: true, clickable: false, action: "", fullWidth: false, color: "red", rgb: RGBColor(red: 0.0, green: 0.0, blue: 0.0, opacity: 0.0)))
    
    @Published var lbBusSchedule = LbBusSchedule(msg: "", attention: "", alerts: [Alert](), routes: [LbRoute]())
    @Published var refreshedLbBusSchedule = LbBusSchedule(msg: "", attention: "", alerts: [Alert](), routes: [LbRoute]())
    @Published var localizedDescription = ""
    @Published var deviceOnlineStatus = ""
    @Published var csbsjuApiOnlineStatus = ""
    
    private var webRequestInProgress: Bool
    public var initalWebRequestFinished: Bool // Used by main view
    
    private var dailyMessage: String
    
    init() {
        self.dailyMessage = ""
        self.webRequestInProgress = false
        self.initalWebRequestFinished = false
        webRequest()
    }
}

extension RouteController {
    
    func webRequest() {
        
        if webRequestInProgress == false {
            webRequestInProgress = true
            self.localizedDescription = "default"
            
            csbsjuApiResponse = BusSchedule(msg: "", attention: "", routes: [Route]())
            linkbusApiResponse = LinkbusApi(alerts: [Alert](), routes: [RouteDetail](), dailyMessage: DailyMessageSettings(id: "321", active: true, clickable: false, action: "", fullWidth: false, color: "red", rgb: RGBColor(red: 0.0, green: 0.0, blue: 0.0, opacity: 0.0)))
            refreshedLbBusSchedule = LbBusSchedule(msg: "", attention: "", alerts: [Alert](), routes: [LbRoute]())
            
            // TODO: Load CSB/SJU API as one group and our API plus daily message requests as another group.
            // We can then display routes when they load and displays alerts after, once they load.
            // Route data from our API can be injected into routes after the fact.
            
            let dispatchGroup = DispatchGroup()
            
            // CSBSJU API
            dispatchGroup.enter()
            fetchCsbsjuApi { apiResponse in
                if apiResponse != nil {
                    DispatchQueue.main.async {
                        self.csbsjuApiResponse = apiResponse!
                        self.csbsjuApiOnlineStatus = "online"
                        //print(self.csbsjuApiResponse)
                        dispatchGroup.leave()
                    }
                }
                else {
                    DispatchQueue.main.async {
                        self.csbsjuApiOnlineStatus = "CsbsjuApi invalid response"
                        dispatchGroup.leave()
                    }
                }
            }
            
            // Daily message alert
            // Website does not always have a message
            dispatchGroup.enter()
            fetchDailyMessage { response in
                if response != nil {
                    DispatchQueue.main.async {
                        self.dailyMessage = response!
                        dispatchGroup.leave()
                    }
                }
            }
            
            // Linkbus API that connects to website
            dispatchGroup.enter()
            fetchLinkbusApi { apiResponse in
                DispatchQueue.main.async {
                    if apiResponse != nil {
                        self.linkbusApiResponse = apiResponse!
                    }
                    dispatchGroup.leave()
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
                    self.deviceOnlineStatus = "offline"
                    self.webRequestInProgress = false
                }
                print("Error with fetching bus schedule from CSBSJU API: \(error)")
                return
            }
            else {
                DispatchQueue.main.async {
                    if self.deviceOnlineStatus == "offline" {
                        self.deviceOnlineStatus = "back online"
                    }
                    else if self.deviceOnlineStatus == "back online" {
                        self.deviceOnlineStatus = "online"
                    }
                    else {
                        self.deviceOnlineStatus = "online"
                    }
                    self.localizedDescription = "no error"
                    
                }
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("Error with the response, unexpected status code: \(String(describing: response))")
                return
            }
            do {
                let apiResponse = try JSONDecoder().decode(BusSchedule.self, from: data!)
                completionHandler(apiResponse)
            } catch {
                print("Error decoding CSB/SJU API!")
                completionHandler(nil)
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
        //        let specifyData = false
        //        if specifyData {
        //            // Allows for date to be changed. Disabled by default. Implement later.
        //            let date = "9/20/2020"
        //            let dateEncoded = date.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        //            postString += "ctl00%24BodyContent%24BusSchedule%24SelectedDate=" + dateEncoded!
        //        }
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
     Fetches the Linkbus API json data including the alerts and additional route info.
     - Parameter completionHandler: The callback function to be executed on successful fetching of API json data.
     
     - Returns: calls completion handler with the API response as argument or returns nill on error.
     */
    func fetchLinkbusApi(completionHandler: @escaping (LinkbusApi?) -> Void) {
        let url = URL(string: LinkbusApiUrl)!
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if let error = error {
                print("Error with fetching bus schedule from Linkbus API: \(error)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("Error with the response, unexpected status code: \(String(describing: response))")
                return
            }
            do {
                let apiResponse = try JSONDecoder().decode(LinkbusApi.self, from: data!)
                completionHandler(apiResponse)
            } catch {
                print("Error decoding Linkbus API!")
                completionHandler(nil)
            }
        })
        task.resume()
    }
    
    func processJson() {
        //print(apiBusSchedule.routes?.count)
        //let busSchedule = BusSchedule(msg: apiBusSchedule.msg!, attention: apiBusSchedule.attention!, routes: apiBusSchedule.routes!)
        
        if(csbsjuApiResponse.msg != nil){
            refreshedLbBusSchedule.msg = csbsjuApiResponse.msg!
        }
        else { refreshedLbBusSchedule.msg = "" }
        if(csbsjuApiResponse.attention != nil){
            refreshedLbBusSchedule.attention = csbsjuApiResponse.attention!
        }
        // Already set to empty string, see refreshedLbBusSchedule declaration
        else { refreshedLbBusSchedule.attention = "" }
        
        for apiAlert in linkbusApiResponse.alerts {
            if (apiAlert.active) {
                refreshedLbBusSchedule.alerts.append(apiAlert)
            }
        }

        refreshedLbBusSchedule.alerts = refreshedLbBusSchedule.alerts.sorted(by: { $0.order < $1.order });

        // Create alert from daily message
        // Website will be able to customize this in the near future
        if self.dailyMessage != "" {
            // Only add to alerts if message is not empty string
            let dailyMessageAlert: Alert;
            // Will be default if not overwritten by our API
            let dailyMessageSettings = linkbusApiResponse.dailyMessage
            // Only render if active
            if(dailyMessageSettings.active) {
                dailyMessageAlert = Alert(id: dailyMessageSettings.id, active: dailyMessageSettings.active, text: self.dailyMessage,
                                          clickable: dailyMessageSettings.clickable, action: dailyMessageSettings.action,
                                          fullWidth: dailyMessageSettings.fullWidth, color: dailyMessageSettings.color,
                                          rgb: dailyMessageSettings.rgb, order: 99)
                refreshedLbBusSchedule.alerts.append(dailyMessageAlert)
            }
        }
        
        // Routes
        if (!csbsjuApiResponse.routes!.isEmpty) {
            for apiRoute in csbsjuApiResponse.routes! {
                var tempRoute = LbRoute(id: 0, title: "", times: [LbTime](), nextBusTimer: "", origin: "", originLocation: "", destination: "", destinationLocation: "", city: "", state: "", coordinates: Coordinates(longitude: 0, latitude: 0))
                tempRoute.id = apiRoute.id!
                tempRoute.title = apiRoute.title!
                var tempTimes = [LbTime]()
                
                var tempId = 0
                for apiTime in apiRoute.times! {
                    // process new time structure
                    if (apiTime.start != "") {
                        // There two aren't being used
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
                            
                            var current = false
                            if (startDate <= Date()) {
                                current = true
                            }
                            
                            
                            let textFormatter = DateFormatter()
                            textFormatter.dateFormat = "h:mm a"
                            
                            let timeString: String = (textFormatter.string(from: startDate) + " - " + (textFormatter.string(from: endDate)))
                            
                            tempId+=1
                            tempTimes.append(LbTime(id: tempId, startDate: startDate, endDate: endDate, timeString: timeString, hasStart: true, lastBusClass: apiTime.lbc!, ss: apiTime.ss!, current: current))
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
                        
                        // current time + 1 min so that a bus at 5:30:00 still appears in app if currentTime is 5:30:01
                        let calendar = Calendar.current
                        let date = Date()
                        let currentDate = calendar.date(byAdding: .minute, value: -1, to: date)
                        
                        if (endDate >= currentDate!) { // make sure end date is not in the past, if true skip add
                            
                            var current = false
                            if (startDate <= Date()) {
                                current = true
                            }
                            
                            let textFormatter = DateFormatter()
                            textFormatter.dateFormat = "h:mm a"
                            
                            let timeString: String = (textFormatter.string(from: endDate))
                            
                            
                            tempId+=1
                            tempTimes.append(LbTime(id: tempId, startDate: startDate, endDate: endDate, timeString: timeString, hasStart: false, lastBusClass: apiTime.lbc!, ss: apiTime.ss!, current: current))
                        }
                    }
                }
                
                if (tempTimes.count > 0) {
                    
                    tempRoute.times = tempTimes
                    
                    // TODO: add in Linkbus API route data
                    if let i = linkbusApiResponse.routes.firstIndex(where: {$0.routeId == tempRoute.id}) {
                        tempRoute.origin = linkbusApiResponse.routes[i].origin
                        tempRoute.originLocation = linkbusApiResponse.routes[i].originLocation
                        tempRoute.destination = linkbusApiResponse.routes[i].destination
                        tempRoute.destinationLocation = linkbusApiResponse.routes[i].destinationLocation
                        tempRoute.city = linkbusApiResponse.routes[i].city
                        tempRoute.state = linkbusApiResponse.routes[i].state
                        tempRoute.coordinates = linkbusApiResponse.routes[i].coordinates
                    }
                    
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
                    
                    refreshedLbBusSchedule.routes.append(tempRoute)
                }
            }
        }
//        print(refreshedLbBusSchedule)
        lbBusSchedule = refreshedLbBusSchedule
        
        //        if (lbBusSchedule.routes.count > 0) {
        //            var iterator = lbBusSchedule.routes[0].times.makeIterator()
        //            while let time = iterator.next() {
        //                print(time.timeString)
        //            }
        //        }
        
        self.webRequestInProgress = false
        // Only change this once
        if(!self.initalWebRequestFinished){
            self.initalWebRequestFinished = true
        }
    }
}
