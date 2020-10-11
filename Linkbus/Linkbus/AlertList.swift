//
//  AlertList.swift
//  Linkbus
//
//  Created by Alex Palumbo on 10/10/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import SwiftUI

struct AlertList: View {
    
    var alerts: [Alert]
    
    init(alerts: [Alert]){
        // routeController: RouteController
        self.alerts = alerts
        print("AlertList init()")
        print("\(self.alerts.count) alerts")
    }
    
    var body: some View {
        if(self.alerts.count > 0){
            VStack(alignment: .leading, spacing: 12){
                ForEach(self.alerts) { alert in
                    AlertCard(alertText: alert.text,
                              alertColor: alert.color,
                              alertRgb: alert.rgb,
                              fullWidth: alert.fullWidth)
                        .transition(.opacity)
                }
                //.listRowBackground((colorScheme == .dark ? Color(UIColor.systemBackground) : Color(UIColor.systemGray6)))
            }
        } else {
            Text("No alerts")
        }
    }
}

//struct AlertList_Previews: PreviewProvider {
//    static var previews: some View {
//        let routeController = RouteController()
//        AlertList(routeController: routeController)
//    }
//}
