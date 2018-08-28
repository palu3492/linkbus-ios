//
//  ViewController.swift
//  Linkbus
//
//  Created by Michael Carroll on 8/27/18.
//  Copyright © 2018 Michael Carroll. All rights reserved.
//

import UIKit

struct BusSchedule: Decodable{
    let msg: String
    let attention: String
    let routes: [Route]
}

struct Route: Decodable{
    let id: Int
    let title: String
    let times: [Time]
}

struct Time: Decodable {
    let start: String
    let end: String
    let lbc: BooleanLiteralType
    let ss: BooleanLiteralType
}

struct GoreckiToSexton {
    let data: [UseableData]
}

struct SextonToGorecki {
    let data: [UseableData]
}

struct CSBEast {
    let data: [UseableData]
}

struct GoreckiToAlcuin {
    let data: [UseableData]
}

struct AlcuinToGorecki {
    let data: [UseableData]
}

struct UseableData {
    let startDate: Date
    let endDate: Date
    let startString: String
    let endString: String
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let jsonUrlString = "https://apps.csbsju.edu/busschedule/api"
        guard let url = URL(string: jsonUrlString) else {return}
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            //check error
            //check response status 200 ok
            guard let data = data else {return}
            
            do {
                let json = try JSONDecoder().decode(BusSchedule.self, from: data)
                print(json.routes[1].times[1].end)
                
                let isoDate = json.routes[1].times[1].end
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM/dd/yyyy h:mm:ss a"
                dateFormatter.timeZone = TimeZone(identifier: "America/Central")
                dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
                let date = dateFormatter.date(from:isoDate)!

                print(dateFormatter.string(from: date))
                
                let goreckiToSexton: GoreckiToSexton
                let sextonToGorecki: SextonToGorecki
                let CSBEast
                
                var iterator = json.routes[0].times.makeIterator()
                while let time = iterator.next() {
                    print(animal)
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
