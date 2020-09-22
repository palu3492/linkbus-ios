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
    
    let alertText: String
    let alertColor: Color
    
    init(alertText: String, alertColor: String, alertRgb: RGBColor) {
        self.alertText = alertText
        
        let color: Color
        
        let colors = [
            "red": Color.red,
            "blue": Color.blue,
            "green": Color.green,
            "yellow": Color.yellow
        ]
        
        if alertColor != "" {
            color = colors[alertColor]!
        } else {
            color = Color(
                red: alertRgb.red,
                green: alertRgb.green,
                blue: alertRgb.blue,
                opacity: alertRgb.opacity
            )
        }
        self.alertColor = color
    }
    
    var body: some View {
        Group(){
            Text(alertText)
                .foregroundColor(Color.white)
                .padding(12)
                .font(Font.custom("HelveticaNeue", size: 14))
        }
        .background(alertColor)
        .cornerRadius(15)
        // .shadow(color: Color.black.opacity(0.2), radius: 7, x: 0, y: 2)
        //https://medium.com/@masamichiueta/bridging-uicolor-system-color-to-swiftui-color-ef98f6e21206
    }
    
}

struct AlertCard_Previews: PreviewProvider {
    static var previews: some View {
        AlertCard(alertText: "A face mask is required to ride the CSB/SJU Link.", alertColor: "red", alertRgb: RGBColor(red: 1.0, green: 0.0, blue: 0.0, opacity: 0.0))
    }
}



