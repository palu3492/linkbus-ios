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
                    Image(systemName: "smallcircle.fill.circle") //stop.circle.fill looks ok
                        .font(.title)
                    Text(route.origin)
                        .font(.title)
                    Spacer()
                }
                .padding([.leading, .trailing], 10)
                .padding([.top, .bottom], 5)
                
                HStack(alignment: .firstTextBaseline) {
                    Image(systemName: "mappin.circle.fill")
                        .font(.title)
                    Text(route.destination)
                        .font(.title)
                    Spacer()
                }
                .padding([.leading, .trailing], 10)
                .padding([.top, .bottom], 5)
                
                Spacer()
            }
            
        }
    }
}

struct RouteSheet_Previews: PreviewProvider {
    static var previews: some View {
        RouteSheet(route: LbRoute(id: 0, title: "Gorecki to Sexton", times: [LbTime](), origin: "Gorecki", originLocation: "Gorecki Center, CSB", destination: "Sexton", destinationLocation: "Sexton Commons, SJU", city: "Collegeville", state: "Minnesota", coordinates: Coordinates(longitude: 0, latitude: 0)))
    }
}
