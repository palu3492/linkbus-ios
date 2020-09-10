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
    
    @State private var totalHeight
        //      = CGFloat.zero       // << variant for ScrollView/List
        = CGFloat.infinity   // << variant for VStack
    
    init(route:LbRoute) {
        self.route = route
        //UIScrollView.appearance().bounces = false
        
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().isTranslucent = true
        UINavigationBar.appearance().tintColor = .clear
        UINavigationBar.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        NavigationView {
            VStack() {
                RoundedRectangle(cornerRadius: CGFloat(5.0) / 2.0)
                    .frame(width: 60, height: 4)
                    .foregroundColor(Color(UIColor.systemGray2))
                    .padding([.top], 10)
                    .padding([.bottom], 5)
                
                ScrollView {
                    
                    VStack(alignment: .leading) {
                        
                        // origin
                        HStack(alignment: .firstTextBaseline) {
                            Image(uiImage: UIImage(systemName: "smallcircle.fill.circle")!) //stop.circle.fill looks ok
                                .renderingMode(.template)
                                //.foregroundColor(Color(red: 43/255, green: 175/255, blue: 187/255))
                                .foregroundColor(Color.blue)
                                .font(.subheadline) //weight: .ultralight))
                                .padding(.leading)
                            
                            
                            Text(route.origin)
                                .font(.title)
                                .padding(.leading)
                            Spacer()
                        }
                        .padding([.top], 5)
                        
                        //origin location
                        HStack(alignment: .firstTextBaseline) {
                            //dash indent?
                            //                    Image(uiImage: UIImage(systemName: "smallcircle.fill.circle")!)//systemName: "smallcircle.fill.circle") //stop.circle.fill looks ok
                            //                        .font(.headline)
                            //                        .padding(.leading)
                            Text("Pickup from " + route.originLocation)
                                .font(.subheadline)
                                .padding(.leading, 45) //fix
                                .padding(.leading)
                                .foregroundColor(Color.gray)
                            Spacer()
                        }
                        .padding([.bottom], 5)
                        
                        // ellipses
                        HStack(alignment: .firstTextBaseline) {
                            Image(systemName: "ellipsis")
                                .rotationEffect(.degrees(90.0))
                                .padding(.leading)
                        }
                        .padding([.top, .bottom], 5)
                        
                        // destination
                        HStack(alignment: .firstTextBaseline) {
                            Image(uiImage: UIImage(systemName: "mappin.circle.fill")!)
                                .renderingMode(.template)
                                //.foregroundColor(Color(red: 43/255, green: 175/255, blue: 187/255))
                                .foregroundColor(Color.blue)
                                .font(.headline)
                                .padding(.leading)
                            Text(route.destination)
                                .font(.title)
                                .padding(.leading)
                            Spacer()
                        }
                        .padding([.top], 5)
                        
                        //destination location
                        HStack(alignment: .lastTextBaseline) {
                            //                    Image(uiImage: UIImage(systemName: "smallcircle.fill.circle")!)//systemName: "smallcircle.fill.circle") //stop.circle.fill looks ok
                            //                        .font(.headline)
                            //                        .padding(.leading)
                            Text("Dropoff at " + route.destinationLocation)
                                .font(.subheadline)
                                .padding(.leading, 45) //fix
                                .padding(.leading)
                                .foregroundColor(Color.gray)
                            Spacer()
                        }
                        
                    }
                    .padding(12)
                    
                    
                    Spacer()
                    
                    
                    
                    //Spacer()
                    
                    VStack(alignment: .leading) {
                        
                        // route times
                        HStack(alignment: .lastTextBaseline) {
                            VStack(alignment: .leading) {
                                ForEach(route.times, id: \.self) { time in
                                    HStack {
                                        Text(time.timeString)
                                            .font(Font.custom("HelveticaNeue", size: 12))
                                            .padding([.leading, .trailing], 10)
                                            .padding([.top, .bottom], 5)
                                            .foregroundColor(Color.white)
                                            //.background(Color(red: 43/255, green: 175/255, blue: 187/255))
                                            .background(Color.blue)
                                            .cornerRadius(7)
                                            .padding([.bottom], 5)
                                        Spacer()
                                    }
                                }
                            }
                            .padding(12)
                            .padding(.leading)
                        }
                        .padding(.leading)
                        .padding([.bottom], 5)
                        
                        
                        
                    }
                    
                }
                    
                    
                .navigationBarTitle("", displayMode: .inline)
                .navigationBarHidden(true)
                
            }
        }
        
    }
}



struct RouteSheet_Previews: PreviewProvider {
    static var previews: some View {
        RouteSheet(route: LbRoute(id: 0, title: "Gorecki to Sexton", times: [LbTime](), nextBusTimer: "5 minutes", origin: "Gorecki", originLocation: "Gorecki Center, CSB", destination: "Sexton", destinationLocation: "Sexton Commons, SJU", city: "Collegeville", state: "Minnesota", coordinates: Coordinates(longitude: 0, latitude: 0)))
    }
}

