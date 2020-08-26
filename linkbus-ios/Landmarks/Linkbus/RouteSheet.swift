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
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                HStack(){
                    Text("")
                }
                .padding()
                // origin
                HStack(alignment: .firstTextBaseline) {
                    Image(uiImage: UIImage(systemName: "smallcircle.fill.circle")!) //stop.circle.fill looks ok
                        .renderingMode(.template)
                        .foregroundColor(Color(red: 43/255, green: 175/255, blue: 187/255))
                        .font(.subheadline) //weight: .ultralight))
                        .padding(.leading)
                    
                    
                    Text(route.origin)
                        .font(.title)
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
                        .foregroundColor(Color(red: 43/255, green: 175/255, blue: 187/255))
                        .font(.headline)
                        .padding(.leading)
                    Text(route.destination)
                        .font(.title)
                    Spacer()
                }
                .padding([.top], 5)
                
                //origin location
                HStack(alignment: .lastTextBaseline) {
                    //                    Image(uiImage: UIImage(systemName: "smallcircle.fill.circle")!)//systemName: "smallcircle.fill.circle") //stop.circle.fill looks ok
                    //                        .font(.headline)
                    //                        .padding(.leading)
                    Text("Dropoff at " + route.destinationLocation)
                        .font(.subheadline)
                        .padding(.leading, 45) //fix
                        .foregroundColor(Color.gray)
                    Spacer()
                }
                .padding([.bottom], 5)
                
                Spacer()
                
                
                // route times
                HStack {
                    VStack {
                        GeometryReader { geometry in
                            self.generateContent(in: geometry)
                        }
                    }
                    .padding(.leading)
                }
                .padding([.bottom], 5)
            }
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarHidden(true)
            
        }
    }
    
    private func generateContent(in g: GeometryProxy) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero
        
        return ZStack(alignment: .topLeading) {
            ForEach(route.times, id: \.self) { time in
                self.item(for: time.timeString)
                    .padding([.horizontal, .vertical], 4)
                    .alignmentGuide(.leading, computeValue: { d in
                        if (abs(width - d.width) > g.size.width)
                        {
                            width = 0
                            height -= d.height
                        }
                        let result = width
                        if time == self.route.times.last! {
                            width = 0 //last item
                        } else {
                            width -= d.width
                        }
                        return result
                    })
                    .alignmentGuide(.top, computeValue: {d in
                        let result = height
                        if time == self.route.times.last! {
                            height = 0 // last item
                        }
                        return result
                    })
            }
        }.background(viewHeightReader($totalHeight))
    }
    
    
    private func item(for text: String) -> some View {
        Text(text)
            .font(Font.custom("SanFrancisco-medium", size: 12))
            .padding([.leading, .trailing], 10)
            .padding([.top, .bottom], 5)
            .foregroundColor(Color.white)
            .background(Color(red: 43/255, green: 175/255, blue: 187/255))
            .cornerRadius(7)
    }
    
    private func viewHeightReader(_ binding: Binding<CGFloat>) -> some View {
        return GeometryReader { geometry -> Color in
            let rect = geometry.frame(in: .local)
            DispatchQueue.main.async {
                binding.wrappedValue = rect.size.height
            }
            return .clear
        }
    }
}

struct RouteSheet_Previews: PreviewProvider {
    static var previews: some View {
        RouteSheet(route: LbRoute(id: 0, title: "Gorecki to Sexton", times: [LbTime](), origin: "Gorecki", originLocation: "Gorecki Center, CSB", destination: "Sexton", destinationLocation: "Sexton Commons, SJU", city: "Collegeville", state: "Minnesota", coordinates: Coordinates(longitude: 0, latitude: 0)))
    }
}
