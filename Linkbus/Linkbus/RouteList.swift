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
    @ObservedObject var routeController = RouteController()
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var counter = 0
    
    var alertPresented: Bool
    @State var menuBarTitle = "Linkbus"
    public var greeting: String
    
    // init removes seperator/dividers from list, in future maybe use scrollview
    init() {
        
        
        //UINavigationBar.setAnimationsEnabled(true)
        UITableView.appearance().separatorStyle = .none
        self.alertPresented = false
        
        let currentDate = Date()
        let calendar = Calendar(identifier: .gregorian)
        let hour = calendar.component(.hour, from: currentDate)
        let component = calendar.dateComponents([.weekday], from: currentDate)
        
        if (hour < 6) {
            let nightGreetings = ["Goodnight 😴", "Buenas noches 😴", "Goodnight 😴", "Goodnight 😴"]
            let randomGreeting = nightGreetings.randomElement()
            self.greeting = randomGreeting!
        }
        else if (hour < 12) {
            //            if (component.weekday == 2) { // if Monday
            //                self.greeting = "Happy Monday 🌅"
            //            }
            //            else if (component.weekday == 6) {
            //                self.greeting = "Happy Friday 🌅"
            //            }
            //            else {
            let morningGreetings = ["Good morning 🌅", "Bonjour 🌅", "Good morning 🌅", "Good morning 🌅"]
            let randomGreeting = morningGreetings.randomElement()
            self.greeting = randomGreeting!
            //            }
        }
        else if (hour < 17) {
            self.greeting = "Good afternoon ☀️"
        }
        else { // < 24
            let eveningGreetings = ["Good evening 🌙", "Buena noches 🌙", "Good evening 🌙", "Good evening 🌙"]
            let randomGreeting = eveningGreetings.randomElement()
            self.greeting = randomGreeting!
        }
        
        //        UITableView.appearance().backgroundColor = (colorScheme == .dark ? .white : .black)
        //        UITableViewCell.appearance().backgroundColor = .clear
        //        UINavigationBar.appearance().backgroundColor = (colorScheme == .dark ? .white : .black)
        //        print(colorScheme)
        
    }
    
    var body: some View {
        if #available(iOS 14.0, *) {
            NavigationView {
                ScrollView {
                    LazyVStack (alignment: .leading, spacing: 12) {
                    ForEach(routeController.lbBusSchedule.alerts) { alert in
                        AlertCard(alertText: alert.text, alertColor: alert.color, alertRgb: alert.rgb)
                            //.transition(.opacity)
                    }
                    }
                    .padding(.top, 4)
                    .padding(.horizontal, 12)
                    //.listRowBackground((colorScheme == .dark ? Color(UIColor.systemBackground) : Color(UIColor.systemGray6)))
                    
                    LazyVStack (alignment: .leading, spacing: 12) {
                        ForEach(routeController.lbBusSchedule.routes) { route in
                            //                    if #available(iOS 13.4, *) {
                            RouteCard(title: route.title, description: route.originLocation, image: Image("Smoothie_Bowl"), price: 15.00, peopleCount: 2, ingredientCount: 2, category: "5 minutes", route: route, buttonHandler: nil)
                            //.animation(.default)
                            //.hoverEffect(.lift)
                            //                    } else {
                            //                        // Fallback on earlier versions
                            //                    }
                            
                        }
//                        .transition(.scale)
//                        .animation(.easeInOut)
                            
                        .shadow(color: Color.black.opacity(0.2), radius: 7, x: 0, y: 2)
                    }
                    .padding(.horizontal, 12)
//                    .transition(.scale)
//                    .animation(.default)
                    
                    
                    //.listRowBackground((colorScheme == .dark ? Color(UIColor.systemBackground) : Color(UIColor.systemGray6)))
                    
                    Text("updated: just now")
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .padding(12)
                
                }
            
                    //.background((colorScheme == .dark ? Color(UIColor.systemBackground) : Color(UIColor.systemGray6)))
                    
                    
                    
                .navigationBarTitle(self.menuBarTitle, displayMode: .large)
                
                //            List(routeController.lbBusSchedule.routes) { route in
                //                VStack (alignment: .leading) {
                //                    Text(route.title)
                //                        .font(.system(size: 11))
                //                        .foregroundColor(Color.gray)
                //                }
                //            }
            }
            .onReceive(timer) { time in
                if self.counter == 1 {
                    self.menuBarTitle = self.greeting
                    self.timer.upstream.connect().cancel()
                }
                
                self.counter += 1
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
                                  fullWidth: alert.fullWidth)
                            .transition(.opacity)
                    }
                    //.listRowBackground((colorScheme == .dark ? Color(UIColor.systemBackground) : Color(UIColor.systemGray6)))
                }
                
                VStack (alignment: .leading, spacing: 12) {
                    ForEach(routeController.lbBusSchedule.routes) { route in
                        //                    if #available(iOS 13.4, *) {
                        RouteCard(title: route.title, description: route.originLocation, image: Image("Smoothie_Bowl"), price: 15.00, peopleCount: 2, ingredientCount: 2, category: "5 minutes", route: route, buttonHandler: nil)
                            .transition(.opacity)
                        
                        //.animation(.default)
                        //.hoverEffect(.lift)
                        //                    } else {
                        //                        // Fallback on earlier versions
                        //                    }
                        
                    }
                        
                    .shadow(color: Color.black.opacity(0.2), radius: 7, x: 0, y: 2)
                }
                .transition(.opacity)
                
                
                //.listRowBackground((colorScheme == .dark ? Color(UIColor.systemBackground) : Color(UIColor.systemGray6)))
                
            }
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
        .onReceive(timer) { time in
            if self.counter == 1 {
                self.menuBarTitle = self.greeting
                self.timer.upstream.connect().cancel()
            }
            
            self.counter += 1
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
