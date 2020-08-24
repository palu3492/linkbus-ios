//
//  NetworkController.swift
//  Linkbus
//
//  Created by Michael Carroll on 8/23/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import SwiftUI

class NetworkController: ObservableObject {
    @Published var dataHasLoaded = false
    
    var apiBusSchedule: BusSchedule!
    var apiRouteDetail: RouteDetail!
    
    let CsbsjuApiUrl = "https://apps.csbsju.edu/busschedule/api/?date=11/1/2019"
    let LinkbusApiUrl = "https://raw.githubusercontent.com/michaelcarroll/linkbus-ios/master/linkbus-ios/Landmarks/Linkbus/Resources/LinkbusAPI.json"
}

extension NetworkController {
    func loadCsbsjuApi(completionHandler: @escaping (BusSchedule) -> Void) {
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
          let api = try? JSONDecoder().decode(BusSchedule.self, from: data) {
          completionHandler(api)
        }
      })
      task.resume()
    }
    
    func loadLinkbusApi() {
        guard let url = URL(string: LinkbusApiUrl) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            //check error
            //check response status 200 ok
            guard let data = data else {return}
            
            do {
                self.apiRouteDetail = try JSONDecoder().decode(RouteDetail.self, from: data)
                
            } catch let jsonErr {
                print("Error serializing json:", jsonErr)
            }
        }.resume()
    }
}



