//
//  RouteSheet.swift
//  Linkbus
//
//  Created by Michael Carroll on 8/25/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import SwiftUI

struct RouteSheet: View {
    var route: LbRoute!
    
    init(route:LbRoute) {
        self.route = route
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                HStack(alignment: .firstTextBaseline) {
                Text("Gorecki")
                    .font(.title)
                Spacer()
                }
                Spacer()
            }
            
        }
    }
}

struct RouteSheet_Previews: PreviewProvider {
    static var previews: some View {
        RouteSheet(route: LbRoute(id: 0, title: "Gorecki to Sexton", times: [LbTime](), location: "Test", city: "Collegeville", state: "Minnesota", coordinates: Coordinates(longitude: 0, latitude: 0)))
    }
}
