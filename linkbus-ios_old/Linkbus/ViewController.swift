//
//  ViewController.swift
//  Linkbus
//
//  Created by Michael Carroll on 8/27/18.
//  Copyright © 2018 Michael Carroll. All rights reserved.
//

import UIKit

struct BusSchedule: Decodable{
    let msg: String?
    let attention: String?
    let routes: [Route]?
}

struct Route: Decodable{
    let id: Int?
    let title: String?
    let times: [Time]?
}

struct Time: Decodable {
    let start: String?
    let end: String?
    let lbc: BooleanLiteralType?
    let ss: BooleanLiteralType?
}

// end of json structs

struct GoreckiToSexton {
    var data: [RouteData]
}

struct SextonToGorecki {
    var data: [RouteData]
}

struct CSBEast {
    var data: [RouteData]
}

struct GoreckiToAlcuin {
    var data: [RouteData]
}

struct AlcuinToGorecki {
    var data: [RouteData]!
}

struct RouteData {
    let startDate: Date
    let endDate: Date
    let timeString: String
    let hasStart: BooleanLiteralType
    let lastBusClass: BooleanLiteralType
    let ss: BooleanLiteralType
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let jsonUrlString = "https://apps.csbsju.edu/busschedule/api/?date=11/1/2019"
        guard let url = URL(string: jsonUrlString) else {return}
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            //check error
            //check response status 200 ok
            guard let data = data else {return}
            
            do {
                let json = try JSONDecoder().decode(BusSchedule.self, from: data)
                print(json.routes![1].times![1].end)
                
                var goreckiToSexton: GoreckiToSexton = GoreckiToSexton(data: [RouteData]())
                var sextonToGorecki: SextonToGorecki = SextonToGorecki(data: [RouteData]())
                var csbEast: CSBEast = CSBEast(data: [RouteData]())
                var goreckiToAlcuin: GoreckiToAlcuin = GoreckiToAlcuin(data: [RouteData]())
                var alcuinToGorecki: AlcuinToGorecki = AlcuinToGorecki(data: [RouteData]())
                
                // === GORECKI TO SEXTION ===
                if !(json.routes!.isEmpty) {
                    var iterator = json.routes![0].times!.makeIterator()
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

                
            } catch let jsonErr {
                print("Error serializing json:", jsonErr)
            }
            }.resume()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
