//
//  AlertList.swift
//  Linkbus
//
//  Created by Alex Palumbo on 11/1/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import SwiftUI

struct AlertList: View {
    
    @ObservedObject var routeController: RouteController
    
    init(routeController: RouteController) {
        self.routeController = routeController
    }
    
    var body: some View {
        
        if #available(iOS 14.0, *) {
            LazyVStack (alignment: .leading, spacing: 12) {
                Alerts(routeController: self.routeController)
            }
            .padding(.top, 4)
            .padding(.horizontal, 12)
            .transition(.scale)
            .animation(.default)
            //.listRowBackground((colorScheme == .dark ? Color(UIColor.systemBackground) : Color(UIColor.systemGray6)))
        } else {
            VStack(alignment: .leading, spacing: 12){
                Alerts(routeController: self.routeController)
            }
            .transition(.opacity)
            .animation(.default)
        }
    }
}

struct Alerts: View {
    let routeController: RouteController
    init(routeController: RouteController) {
        self.routeController = routeController
    }
    var body: some View {
        if (routeController.localizedDescription == "The Internet connection appears to be offline.") {
            AlertCard(alertText: "⚠️ No internet connection. Tap to retry.", alertColor: "red", alertRgb: RGBColor(red: 1.0, green: 0.0, blue: 0.0, opacity: 0.0), fullWidth: true, clickable: true, action: "webRequest", routeController: routeController)
            AlertCard(alertText: "Or, tap here to try the bus schedule website.", alertColor: "blue", alertRgb: RGBColor(red: 1.0, green: 0.0, blue: 0.0, opacity: 0.0), fullWidth: true, clickable: true, action: "https://apps.csbsju.edu/busschedule/", routeController: routeController)
        }
        if (routeController.deviceOnlineStatus == "back online") {
            AlertCard(alertText: "Back online. 🥳", alertColor: "blue", alertRgb: RGBColor(red: 1.0, green: 0.0, blue: 0.0, opacity: 0.0), fullWidth: false, clickable: false, action: "", routeController: routeController)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                        routeController.deviceOnlineStatus = "online"
                    }
                }
        }
        if (routeController.csbsjuApiOnlineStatus == "CsbsjuApi invalid response") {
            AlertCard(alertText: "⚠️ CSB/SJU servers appear to be offline. Tap to retry.", alertColor: "red", alertRgb: RGBColor(red: 1.0, green: 0.0, blue: 0.0, opacity: 0.0), fullWidth: true, clickable: true, action: "webRequest", routeController: routeController)
            AlertCard(alertText: "Or, tap here to try the bus schedule website.", alertColor: "blue", alertRgb: RGBColor(red: 1.0, green: 0.0, blue: 0.0, opacity: 0.0), fullWidth: true, clickable: true, action: "https://apps.csbsju.edu/busschedule/", routeController: routeController)
        }
        ForEach(routeController.lbBusSchedule.alerts) { alert in
            AlertCard(alertText: alert.text, alertColor: alert.color, alertRgb: alert.rgb, fullWidth: alert.fullWidth, clickable: alert.clickable, action: alert.action, routeController: routeController)
            //.transition(.opacity)
        }
        //.listRowBackground((colorScheme == .dark ? Color(UIColor.systemBackground) : Color(UIColor.systemGray6)))
    }
}

//struct AlertList_Previews: PreviewProvider {
//    static var previews: some View {
//        AlertList()
//    }
//}
