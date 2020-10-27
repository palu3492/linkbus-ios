/*
 See LICENSE folder for this sample’s licensing information.
 
 Abstract:
 A view showing a list of landmarks.
 */

import SwiftUI
import Foundation
import Combine

struct RouteList: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var routeController: RouteController
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var counter = 0
    
    var alertPresented: Bool
    @State var timeOfDay = "default"
    
    @State var menuBarTitle = "Linkbus"
    @State var initial = true
    @State var lastRefreshTime = ""
    @State var greeting = "Linkbus"
    
    // init removes seperator/dividers from list, in future maybe use scrollview
    init() {
        self.routeController = RouteController()
        
        //UINavigationBar.setAnimationsEnabled(true)
        UITableView.appearance().separatorStyle = .none
        
        self.alertPresented = false
        
        
        
        //        UITableView.appearance().backgroundColor = (colorScheme == .dark ? .white : .black)
        //        UITableViewCell.appearance().backgroundColor = .clear
        //        UINavigationBar.appearance().backgroundColor = (colorScheme == .dark ? .white : .black)
        //        print(colorScheme)
        
        let time = Date()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        lastRefreshTime = timeFormatter.string(from: time)
        
    }
    
    var body: some View {
        if #available(iOS 14.0, *) {
            NavigationView {
                ScrollView {
                    LazyVStack (alignment: .leading, spacing: 12) {
                        ForEach(routeController.lbBusSchedule.alerts) { alert in
                            AlertCard(alertText: alert.text, alertColor: alert.color, alertRgb: alert.rgb, fullWidth: alert.fullWidth, clickable: alert.clickable, action: alert.action)
                            //.transition(.opacity)
                        }
                    }
                    .padding(.top, 4)
                    .padding(.horizontal, 12)
                    .transition(.scale)
                    .animation(.default)
                    //.listRowBackground((colorScheme == .dark ? Color(UIColor.systemBackground) : Color(UIColor.systemGray6)))
                    
                    LazyVStack (alignment: .leading, spacing: 12) {
                        ForEach(routeController.lbBusSchedule.routes) { route in
                            //                    if #available(iOS 13.4, *) {
                            RouteCard(title: route.title, description: route.originLocation, image: Image("Smoothie_Bowl"), price: 15.00, peopleCount: 2, ingredientCount: 2, category: "5 minutes", route: route, buttonHandler: nil)
                            //.animation(.default)
                            //                    } else {
                            //                        // Fallback on earlier versions
                            //                    }
                            
                        }
                        //                        .transition(.scale)
                        //                        .animation(.easeInOut)
                        
                        .shadow(color: Color.black.opacity(0.2), radius: 7, x: 0, y: 2)
                    }
                    .padding(.horizontal, 12)
                    .transition(.scale)
                    .animation(.default)
                    .padding(.top, 4)
                    
                    //.listRowBackground((colorScheme == .dark ? Color(UIColor.systemBackground) : Color(UIColor.systemGray6)))
                    
                    
                    //                    Text("updated: just now")
                    //                        .font(.footnote)
                    //                        .foregroundColor(.gray)
                    //                        .padding(12)
                    
                }
                .padding(.top, 1) // !! FIXES THE WEIRD NAVIGATION BAR GRAPHICAL GLITCHES WITH SCROLLVIEW IN NAVVIEW
                
                //.background((colorScheme == .dark ? Color(UIColor.systemBackground) : Color(UIColor.systemGray6)))
                
                
                
                .navigationBarTitle(self.menuBarTitle)
                
                
                //            List(routeController.lbBusSchedule.routes) { route in
                //                VStack (alignment: .leading) {
                //                    Text(route.title)
                //                        .font(.system(size: 11))
                //                        .foregroundColor(Color.gray)
                //                }
                //            }
            }
            .hoverEffect(.lift)
            .onReceive(timer) { time in
                if self.counter >= 2 {
                    
                    let currentDate = Date()
                    let calendar = Calendar(identifier: .gregorian)
                    let hour = calendar.component(.hour, from: currentDate)
                    let component = calendar.dateComponents([.weekday], from: currentDate)
                    
                    var newTimeOfDay: String
                    var timeOfDayChanged = false
                    
                    if (hour < 6) {
                        newTimeOfDay = "night"
                    }
                    else if (hour < 12) {
                        newTimeOfDay = "morning"
                    }
                    else if (hour < 17) {
                        newTimeOfDay = "afternoon"
                    }
                    else { //< 24
                        newTimeOfDay = "evening"
                    }
                    
                    if (newTimeOfDay != self.timeOfDay) {
                        timeOfDayChanged = true
                        self.timeOfDay = newTimeOfDay
                    }
                    
                    if (timeOfDayChanged) { // timeOfDayChanged will make it immediately run on first laucnh -- fix-try this
                        
                        if (self.timeOfDay == "night") {
                            let nightGreetings = ["Goodnight 😴", "Buenas noches 😴", "Goodnight 😴", "Goodnight 😴"]
                            let randomGreeting = nightGreetings.randomElement()
                            self.greeting = randomGreeting!
                        }
                        else if (self.timeOfDay == "morning") {
                            if (component.weekday == 2) { // if Monday
                                self.greeting = "Happy Monday 🌅"
                            }
                            else if (component.weekday == 6) {
                                self.greeting = "Happy Friday 🌅"
                            }
                            else {
                                let morningGreetings = ["Good morning 🌅", "Bonjour 🌅", "Good morning 🌅", "Good morning 🌅", "Good morning 🌅", "Buenos días 🌅"]
                                let randomGreeting = morningGreetings.randomElement()
                                self.greeting = randomGreeting!
                            }
                        }
                        else if (self.timeOfDay == "afternoon") {
                            self.greeting = "Good afternoon ☀️"
                        }
                        else if (self.timeOfDay == "evening") { // < 24 , self.timeOfDay = evening
                            let eveningGreetings = ["Good evening 🌙", "Good evening 🌙", "Good evening 🌙", "Good evening 🌙"]
                            let randomGreeting = eveningGreetings.randomElement()
                            self.greeting = randomGreeting!
                        }
                        self.menuBarTitle = self.greeting
                    }
                }
                
                self.counter += 1
                
                let time = Date()
                let timeFormatter = DateFormatter()
                timeFormatter.dateFormat = "HH:mm"
                let currentTime = timeFormatter.string(from: time)
                if self.lastRefreshTime != currentTime {
                    self.routeController.webRequest()
                    self.lastRefreshTime = currentTime
                }
            }
            
        }
        
        else {//IOS 13
            
            NavigationView {
                List() {
                    VStack(alignment: .leading, spacing: 12){
                        ForEach(routeController.lbBusSchedule.alerts) { alert in
                            AlertCard(alertText: alert.text,
                                      alertColor: alert.color,
                                      alertRgb: alert.rgb,
                                      fullWidth: alert.fullWidth,
                                      clickable: alert.clickable,
                                      action: alert.action)
//                                .transition(.opacity)
//                                .animation(.default)
                        }

                        //.listRowBackground((colorScheme == .dark ? Color(UIColor.systemBackground) : Color(UIColor.systemGray6)))
                    }
                    .transition(.opacity)
                    .animation(.default)
                    
                    VStack (alignment: .leading, spacing: 12) {
                        ForEach(routeController.lbBusSchedule.routes) { route in
                            //                    if #available(iOS 13.4, *) {
                            RouteCard(title: route.title, description: route.originLocation, image: Image("Smoothie_Bowl"), price: 15.00, peopleCount: 2, ingredientCount: 2, category: "5 minutes", route: route, buttonHandler: nil)
//                                .transition(.opacity)
//                                .animation(.default)
                            
                            //.animation(.default)
                            //.hoverEffect(.lift)
                            //                    } else {
                            //                        // Fallback on earlier versions
                            //                    }
                            
                        }
                        
                        .shadow(color: Color.black.opacity(0.2), radius: 7, x: 0, y: 2)
                    }
                    .transition(.opacity)
                    .animation(.default)

                    //.animation(.default)
                    //.transition(.opacity)
                    
                    
                    //.listRowBackground((colorScheme == .dark ? Color(UIColor.systemBackground) : Color(UIColor.systemGray6)))
                    
                }
                .transition(.opacity)
                .animation(.default)
                //.transition(.opacity)
                .navigationBarTitle(self.menuBarTitle)
                //.background((colorScheme == .dark ? Color(UIColor.systemBackground) : Color(UIColor.systemGray6)))
                
                
                
                
                
                //            List(routeController.lbBusSchedule.routes) { route in
                //                VStack (alignment: .leading) {
                //                    Text(route.title)
                //                        .font(.system(size: 11))
                //                        .foregroundColor(Color.gray)
                //                }
                //            }
            }
            .onReceive(timer) { time in
                if self.counter >= 2 {
                    
                    let currentDate = Date()
                    let calendar = Calendar(identifier: .gregorian)
                    let hour = calendar.component(.hour, from: currentDate)
                    let component = calendar.dateComponents([.weekday], from: currentDate)
                    
                    var newTimeOfDay: String
                    var timeOfDayChanged = false
                    
                    if (hour < 6) {
                        newTimeOfDay = "night"
                    }
                    else if (hour < 12) {
                        newTimeOfDay = "morning"
                    }
                    else if (hour < 17) {
                        newTimeOfDay = "afternoon"
                    }
                    else { //< 24
                        newTimeOfDay = "evening"
                    }
                    
                    if (newTimeOfDay != self.timeOfDay) {
                        timeOfDayChanged = true
                        self.timeOfDay = newTimeOfDay
                    }
                    
                    if (timeOfDayChanged) { // timeOfDayChanged will make it immediately run on first laucnh -- fix-try this
                        
                        if (self.timeOfDay == "night") {
                            let nightGreetings = ["Goodnight 😴", "Buenas noches 😴", "Goodnight 😴", "Goodnight 😴"]
                            let randomGreeting = nightGreetings.randomElement()
                            self.greeting = randomGreeting!
                        }
                        else if (self.timeOfDay == "morning") {
                            if (component.weekday == 2) { // if Monday
                                self.greeting = "Happy Monday 🌅"
                            }
                            else if (component.weekday == 6) {
                                self.greeting = "Happy Friday 🌅"
                            }
                            else {
                                let morningGreetings = ["Good morning 🌅", "Bonjour 🌅", "Good morning 🌅", "Good morning 🌅", "Good morning 🌅", "Buenos días 🌅"]
                                let randomGreeting = morningGreetings.randomElement()
                                self.greeting = randomGreeting!
                            }
                        }
                        else if (self.timeOfDay == "afternoon") {
                            self.greeting = "Good afternoon ☀️"
                        }
                        else if (self.timeOfDay == "evening") { // < 24 , self.timeOfDay = evening
                            let eveningGreetings = ["Good evening 🌙", "Good evening 🌙", "Good evening 🌙", "Good evening 🌙"]
                            let randomGreeting = eveningGreetings.randomElement()
                            self.greeting = randomGreeting!
                        }
                        self.menuBarTitle = self.greeting
                    }
                }
                
                self.counter += 1
                
                let time = Date()
                let timeFormatter = DateFormatter()
                timeFormatter.dateFormat = "HH:mm"
                let currentTime = timeFormatter.string(from: time)
                if self.lastRefreshTime != currentTime {
                    self.routeController.webRequest()
                    self.lastRefreshTime = currentTime
                }
            }
            
        }
        
    }
}

//    var body: some View {

////                        .onAppear() {
////                            self.routeController.webRequest()
////                    }
//                }
//            }
//            .navigationBarTitle(Text("Landmarks"))
//        }
//    }
//}

struct LandmarkList_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(["iPhone XS Max"], id: \.self) { deviceName in
            RouteList()
                .previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName(deviceName)
        }
    }
}

