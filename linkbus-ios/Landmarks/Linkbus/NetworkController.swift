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
    
    let csbsjuApiUrl = "https://apps.csbsju.edu/busschedule/api/?date=2/1/2020"
    let LinkbusApiUrl = "https://raw.githubusercontent.com/michaelcarroll/linkbus-ios/master/linkbus-ios/Landmarks/Linkbus/Resources/LinkbusAPI.json"
}

extension NetworkController {
    func loadCsbsjuApi(completionHandler: @escaping (ApiBusSchedule) -> Void) {
        let url = URL(string: csbsjuApiUrl)!
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if let error = error {
                print("Error fetching from CSB/SJU API: \(error)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                    print("Error with the response, unexpected status code: \(response)")
                    return
            }
            
            if let data = data,
                let apiBusSchedule = try? JSONDecoder().decode(ApiBusSchedule.self, from: data) {
                completionHandler(apiBusSchedule)
            }
        })
        task.resume()
    }
    
    
    func loadLinkbusApi(completionHandler: @escaping (ApiBusSchedule) -> Void) {
        let url = URL(string: LinkbusApiUrl)!
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if let error = error {
                print("Error fetching from my GitHub API: \(error)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                    print("Error with the response, unexpected status code: \(response)")
                    return
            }
            
            if let data = data,
                let apiBusSchedule = try? JSONDecoder().decode(ApiBusSchedule.self, from: data) {
                completionHandler(apiBusSchedule)
            }
        })
        task.resume()
    }
    
    
}

