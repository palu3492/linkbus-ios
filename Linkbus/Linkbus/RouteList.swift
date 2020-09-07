/*
 See LICENSE folder for this sample’s licensing information.
 
 Abstract:
 A view showing a list of landmarks.
 */

import SwiftUI
import Foundation
import Combine


struct RouteList: View {
    @ObservedObject var routeController = RouteController()
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var counter = 0
    
    var alertPresented: Bool
    @State var menuBarTitle = "Linkbus"
    public var greeting: String
    
    // init removes seperator/dividers from list, in future maybe use scrollview
    init() {
        
        UINavigationBar.setAnimationsEnabled(true)
        UITableView.appearance().separatorStyle = .none
        self.alertPresented = false
        
        let currentDate = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: currentDate)
        
        
        if (hour < 6) {
            self.greeting = "Goodnight 😴"
        }
        else if (hour < 12) {
            self.greeting = "Good morning 🌅"
        }
        else if (hour < 17) {
            self.greeting = "Good afternoon ☀️"
        }
        else { // < 24
            self.greeting = "Good evening 🌙"
        }
    }
    
        var body: some View {
            NavigationView {
                List() {
                    ForEach(routeController.lbBusSchedule.alerts) { alert in
                        AlertCard(alertText: alert.text, alertColor: alert.color)
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
                        //.shadow(color: Color.black.opacity(0.2), radius: 7, x: 0, y: 2)
                    }
                    }
                    .shadow(color: Color.black.opacity(0.2), radius: 7, x: 0, y: 2)
                        }
                            
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
