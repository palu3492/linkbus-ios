//
//  ProductCard.swift
//  FoodProductCard
//
//  Created by Jean-Marc Boullianne on 11/17/19.
//  Copyright © 2019 Jean-Marc Boullianne. All rights reserved.
//
import SwiftUI

struct AlertCard: View {
    
    
    @State private var totalHeight
        //      = CGFloat.zero       // << variant for ScrollView/List
        = CGFloat.infinity   // << variant for VStack
    
    //var landmark: Landmark
    var alertText: String
    var alertColor: Color
    
    init(alertText: String, alertColor: String) {
        self.alertText = alertText
        
        var color = Color(UIColor.secondarySystemBackground)
        
        if (alertColor == "red") {
            color = Color.red
        }
        else if (alertColor == "green") {
            color = Color.green
        }
        else if (alertColor == "blue") {
            color = Color.blue
        }
        else if (alertColor == "yellow") {
            color = Color.yellow
        }
        
        self.alertColor = color
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            // Stack bottom half of card
            VStack(alignment: .leading) {
                
                
                
                // Price and Buy Now Stack
                HStack(alignment: .center, spacing: 0) {
                    Text(alertText)
                        .foregroundColor(Color.white)
                }.font(Font.custom("HelveticaNeue", size: 14))
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
            .background(alertColor)
            .cornerRadius(15)
        //.shadow(color: Color.black.opacity(0.2), radius: 7, x: 0, y: 2)
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


struct AlertCard_Previews: PreviewProvider {
    static var previews: some View {
        AlertCard(alertText: "A face mask is required to ride the CSB/SJU Link.", alertColor: "red")
    }
}



