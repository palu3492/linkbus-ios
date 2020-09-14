//
//  TestDatePick.swift
//  Linkbus
//
//  Created by Alex Palumbo on 9/11/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import SwiftUI

struct SelectDate: View {
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }
    
    @ObservedObject var routeController = RouteController()

    @State private var lbScheduleDate: Date = Date()
    
    @State private var showDatePicker: Bool = true
    @State private var datePickerButtonText: String = "Done"
    
    var editButton: some View {
        Button(action: {
            self.datePickerButtonText = self.showDatePicker ? "Edit" : "Done"
            self.showDatePicker.toggle()
        }) {
            Text(self.datePickerButtonText)
                .fontWeight(.semibold)
                .font(Font.custom("HelveticaNeue", size: 18))
                .foregroundColor(Color.blue)
        }
    }
    
    var datePicker: some View {
        DatePicker("", selection: $lbScheduleDate, displayedComponents: .date)
            .transition(.slide)
            .animation(.spring())
    }

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            Divider()
            .padding(.top, 12)
            
            VStack(alignment: .leading, spacing: 12){
                HStack(){
                    Spacer()
                    Text("\(lbScheduleDate, formatter: dateFormatter)")
                    Spacer()
                    self.editButton
                    Spacer()
                }
                if self.showDatePicker {
                    self.datePicker
                }
            }
            
            Divider()
                .padding(.bottom, 12)
            
            VStack(alignment: .leading, spacing: 12){
                ForEach(routeController.lbBusSchedule.routes) { route in
                    RouteCard(title: route.title, description: route.originLocation, image: Image("Smoothie_Bowl"), price: 15.00, peopleCount: 2, ingredientCount: 2, category: "5 minutes", route: route, buttonHandler: nil)
                        .transition(.opacity)
                }
                .shadow(color: Color.black.opacity(0.2), radius: 7, x: 0, y: 2)
            }
        }
        .navigationBarTitle(Text("Select Date"))
    }
}

//struct TestDatePick_Previews: PreviewProvider {
//    static var previews: some View {
//        TestDatePick()
//    }
//}
