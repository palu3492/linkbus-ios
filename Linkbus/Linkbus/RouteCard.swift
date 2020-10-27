//
//  ProductCard.swift
//  FoodProductCard
//
//  Created by Jean-Marc Boullianne on 11/17/19.
//  Copyright © 2019 Jean-Marc Boullianne. All rights reserved.
//
import SwiftUI

struct RouteCard: View {
    
    @State var showRouteSheet = false
    
    var image:Image     // Featured Image
    var price:Double    // USD
    var title:String    // Product Title
    var description:String // Product Description
    var ingredientCount:Int // # of Ingredients
    var peopleCount:Int     // Servings
    var category:String?    // Optional Category
    var buttonHandler: (()->())?
    
    @State var timer = "Now"
    
    var route: LbRoute!
    
    @State private var totalHeight
        //      = CGFloat.zero       // << variant for ScrollView/List
        = CGFloat.infinity   // << variant for VStack
    @Environment(\.colorScheme) var colorScheme
    
    //var landmark: Landmark
    
    init(title:String, description:String, image:Image, price:Double, peopleCount:Int, ingredientCount:Int, category:String?, route:LbRoute, buttonHandler: (()->())?) {
        
        self.title = title
        self.description = description
        self.image = image
        self.price = price
        self.peopleCount = peopleCount
        self.ingredientCount = ingredientCount
        self.category = category
        self.buttonHandler = buttonHandler
        self.route = route
        
        self.timer = "Now"
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            // Stack bottom half of card
            VStack(alignment: .leading) {
                
                HStack(alignment: .center) {
                    Text(self.title)
                        .font(Font.custom("HelveticaNeue", size: 18))
                        .font(.headline)
                        .fontWeight(.regular)
                    Spacer()
                    
                    VStack (alignment: .leading, spacing: 0) {
                        HStack(alignment: .center) {
                            Spacer()
                            Text("Next bus")
                                .font(Font.custom("HelveticaNeue", size: 12))
                                //.font(.subheadline)
                                //.fontWeight(.regular)
                                .foregroundColor(Color.gray)
                        }
                        HStack(alignment: .center) {
                            Spacer()
                            if (route.nextBusTimer == "Departing now") {
                                Text(route.nextBusTimer)
                                    .font(Font.custom("HelveticaNeue", size: 14))
                                    //.font(.footnote)
                                    .padding([.leading, .trailing], 5)
                                    .padding([.top, .bottom], 2.5)
                                    .foregroundColor(Color.white)
                                    //.background(Color(red: 43/255, green: 175/255, blue: 187/255))
                                    .background(Color.red)
                                    .cornerRadius(7)
                                    .padding([.top, .bottom], 4)
                            }
                            else if (route.nextBusTimer.contains("Now")) {
                                let delay = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { (delay) in
                                    self.timer = route.nextBusTimer
                                    print("executed")
                                }
                                Text(timer)
                                    .font(Font.custom("HelveticaNeue", size: 14))
                                    //.fontWeight(.medium)
                                    //.font(.footnote)
                                    .padding([.leading, .trailing], 5)
                                    .padding([.top, .bottom], 2.5)
                                    .foregroundColor(Color.white)
                                    //.background(Color(red: 43/255, green: 175/255, blue: 187/255))
                                    .background(Color.green)
                                    .cornerRadius(7)
                                    .padding([.top, .bottom], 4)
                            }
                            else {
                                
                                Text(route.nextBusTimer)
                                    .font(Font.custom("HelveticaNeue", size: 14))
                                    //.fontWeight(.medium)
                                    //.font(.footnote)
                                    .padding([.leading, .trailing], 5)
                                    .padding([.top, .bottom], 2.5)
                                    .foregroundColor(Color.white)
                                    //                            .background(Color(red: 43/255, green: 175/255, blue: 187/255))
                                    .background(Color.blue)
                                    .cornerRadius(7)
                                    .padding([.top, .bottom], 4)
                            }
                        }
                        .transition(.scale)
                        .animation(.default)
                    }
                }
                
                .padding([.top, .bottom], 8)
                
                //                HStack(alignment: .center, spacing: 4) {
                //                    Text(String.init(format: "$%.2f", arguments: [self.price]))
                //                        .fontWeight(Font.Weight.heavy)
                //                    Text("for 2 people")
                //                        .font(Font.system(size: 13))
                //                        .fontWeight(Font.Weight.bold)
                //                        .foregroundColor(Color.gray)
                //                    Spacer()
                //                    Image("Plus-Icon")
                //                        .resizable()
                //                        .scaledToFit()
                //                        .frame(width: 15, height: 15, alignment: .center)
                //                        .colorMultiply(Color(red: 231/255, green: 119/255, blue: 112/255))
                //                        .onTapGesture {
                //                            self.buttonHandler?()
                //                    }
                //                    Text("BUY NOW")
                //                        .fontWeight(Font.Weight.heavy)
                //                        .foregroundColor(Color(red: 231/255, green: 119/255, blue: 112/255))
                //                        .onTapGesture {
                //                            self.buttonHandler?()
                //                    }
                //
                //                }.padding([.top, .bottom], 8)
                
                
            }
            .padding(12)
            
        }
        //https://medium.com/@masamichiueta/bridging-uicolor-system-color-to-swiftui-color-ef98f6e21206
        .background(colorScheme == .dark ? Color(UIColor.secondarySystemBackground) : Color(UIColor.systemBackground))
        .cornerRadius(15)
        //.shadow(color: Color.black.opacity(0.2), radius: 7, x: 0, y: 2)
        .onTapGesture {
            self.showRouteSheet = true
        }.sheet(isPresented: $showRouteSheet) {
            RouteSheet(route: self.route)
        }
    }
    
}

//    var body: some View {
//
//        VStack(alignment: .leading, spacing: 0) {
//
//            // Main Featured Image - Upper Half of Card
//
//
//            // Stack bottom half of card
//            VStack(alignment: .leading, spacing: 6) {
//                Text(self.title)
//                    .font(.headline)
//                    .fontWeight(Font.Weight.heavy)
//                Text(self.description)
//                    //.font(Font.custom("HelveticaNeue-Bold", size: 16))
//                    .font(.subheadline)
//                    .foregroundColor(Color.gray)
//
//                // Horizontal Line separating details and price
//                Rectangle()
//                    .foregroundColor(Color.gray.opacity(0.3))
//                    .frame(width: nil, height: 1, alignment: .center)
//                    .padding([.leading, .trailing], -12)
//
//                // 'Based on:' Horizontal Category Stack
//                HStack(alignment: .center, spacing: 6) {
//
//                    if category != nil {
//                        Text("Next bus:")
//                            .font(Font.system(size: 13))
//                            .fontWeight(Font.Weight.heavy)
//                        HStack {
//                            Text(category!)
//                                .font(Font.custom("SanFrancisco-medium", size: 12))
//                                .padding([.leading, .trailing], 10)
//                                .padding([.top, .bottom], 5)
//                                .foregroundColor(Color.white)
//                        }
//                        .background(Color(red: 43/255, green: 175/255, blue: 187/255))
//                        .cornerRadius(7)
//                        Spacer()
//                    }
//
////                    HStack(alignment: .center, spacing: 0) {
////                        Text("")
////                            .foregroundColor(Color.gray)
////                        Text("\(self.ingredientCount)")
////                    }.font(Font.custom("HelveticaNeue", size: 14))
//
//
//                }
//                .frame(maxHeight: totalHeight) // << variant for VStack
//                .padding([.top, .bottom], 8)
//
//
//            }
//            .padding(12)
//
//
//
//        }
//
//            //https://medium.com/@masamichiueta/bridging-uicolor-system-color-to-swiftui-color-ef98f6e21206
//        .background(Color(UIColor.secondarySystemBackground))
//        .cornerRadius(15)
//        .shadow(color: Color.black.opacity(0.2), radius: 7, x: 0, y: 2)
//        .onTapGesture {
//            self.showRouteSheet = true
//        }.sheet(isPresented: $showRouteSheet) {
//            RouteSheet(route: self.route)
//        }
//
//    }
//
//


struct ProductCard_Previews: PreviewProvider {
    static var previews: some View {
        RouteCard(title: "Gorecki to Sexton", description: "Gorecki Center", image: Image("Smoothie_Bowl"), price: 15.00, peopleCount: 2, ingredientCount: 2, category: "5 minutes", route: LbRoute(id: 0, title: "Test", times: [LbTime](), nextBusTimer: "5 mintutes", origin: "Gorecki", originLocation: "Gorecki Center, CSB", destination: "Sexton", destinationLocation: "Sexton Commons, SJU", city: "Collegeville", state: "Minnesota", coordinates: Coordinates(longitude: 0, latitude: 0)), buttonHandler: nil)
    }
}

struct RoundedCorners: Shape {
    var tl: CGFloat = 0.0
    var tr: CGFloat = 0.0
    var bl: CGFloat = 0.0
    var br: CGFloat = 0.0
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let w = rect.size.width
        let h = rect.size.height
        
        let tr = min(min(self.tr, h/2), w/2)
        let tl = min(min(self.tl, h/2), w/2)
        let bl = min(min(self.bl, h/2), w/2)
        let br = min(min(self.br, h/2), w/2)
        
        path.move(to: CGPoint(x: w / 2.0, y: 0))
        path.addLine(to: CGPoint(x: w - tr, y: 0))
        path.addArc(center: CGPoint(x: w - tr, y: tr), radius: tr,
                    startAngle: Angle(degrees: -90), endAngle: Angle(degrees: 0), clockwise: false)
        
        path.addLine(to: CGPoint(x: w, y: h - br))
        path.addArc(center: CGPoint(x: w - br, y: h - br), radius: br,
                    startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 90), clockwise: false)
        
        path.addLine(to: CGPoint(x: bl, y: h))
        path.addArc(center: CGPoint(x: bl, y: h - bl), radius: bl,
                    startAngle: Angle(degrees: 90), endAngle: Angle(degrees: 180), clockwise: false)
        
        path.addLine(to: CGPoint(x: 0, y: tl))
        path.addArc(center: CGPoint(x: tl, y: tl), radius: tl,
                    startAngle: Angle(degrees: 180), endAngle: Angle(degrees: 270), clockwise: false)
        
        return path
    }
}

