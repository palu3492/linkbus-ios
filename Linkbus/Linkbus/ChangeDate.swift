//
//  ChangeDateSheet.swift
//  Linkbus
//
//  Created by Alex Palumbo on 11/27/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import SwiftUI

struct ChangeDate: View {
    
    @State private var selectedDate: Date
    @ObservedObject var routeController: RouteController
    @State private var showDatePicker = true
    @Environment(\.presentationMode) var presentationMode
    
    private var dateProxy:Binding<Date> {
        Binding<Date>(get: {self.selectedDate }, set: {
            self.selectedDate = $0
            self.routeController.selectedDate = self.selectedDate
            self.routeController.onDateChanged()
        })
    }
    
    init(routeController: RouteController) {
        self.routeController = routeController
        let now = Date()
        self._selectedDate = State<Date>(initialValue: now)
    }
    
    static let goalFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    var body: some View {
        ScrollView() {
            // This VStack in charge of placing elements correctly, ScrollView won't on its own
            VStack(spacing: 0) {
                VStack(spacing: 14) {
                    HStack {
                        Text("Select Date")
                            .bold()
                            .font(.title)
                        Spacer()
//                        Button("Done") {
//                            print("Close")
//                        }
                        Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                        }) {
                            Text("Done")
                        }
                    }
                    if false { // iOS 14
//                        VStack(alignment: .leading, spacing: 20) {
//                            // Date Picker
//                            DatePicker(
//                                selection: dateProxy,
//                                displayedComponents: .date,
//                                label:{ Text("Selected Date") }
//                            )
//                            .labelsHidden()
//                            .datePickerStyle(GraphicalDatePickerStyle())
//                        }
                    } else {
                        VStack(alignment: .leading, spacing: 0) {
                            Button(action: {
                                withAnimation {
                                    self.showDatePicker.toggle()
                                }
                            }) {
                                HStack{
                                    Text("\(self.selectedDate, formatter: Self.goalFormat)")
                                    Spacer()
                                    Image(systemName: "chevron.right.circle")
                                        .imageScale(.large)
                                        .rotationEffect(.degrees(showDatePicker ? 90 : 0))
                                        .padding(.vertical)
                                }
                                .padding(.horizontal)
                            }
                            if showDatePicker {
                                Divider()
                                if #available(iOS 14.0, *) {
                                    DatePicker(
                                        selection: dateProxy,
                                        displayedComponents: .date,
                                        label:{ Text("Selected Date") }
                                    )
                                    .labelsHidden()
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .datePickerStyle(GraphicalDatePickerStyle())
                                    .padding(.horizontal)
                                    .padding(.top, 6)
                                } else {
                                    DatePicker(
                                        selection: dateProxy,
                                        displayedComponents: .date,
                                        label:{ Text("Selected Date") }
                                    )
                                    .labelsHidden()
                                    .frame(maxWidth: .infinity, alignment: .center)
                                }
                            }
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.secondary, lineWidth: 1)
                        )
                    }
                }
                .padding() // Padding for everything above the routes
                RouteList(routeController: routeController)
            }
        }
        
    }
    
//    struct Info: View {
//        var body: some View {
//
//        }
//    }
    
}

//struct ChangeDate_Previews: PreviewProvider {
//    static var previews: some View {
//        ChangeDate()
//    }
//}
