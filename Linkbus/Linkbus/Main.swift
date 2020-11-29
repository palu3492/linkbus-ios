//
//  Home.swift
//  Linkbus
//
//  Created by Alex Palumbo on 11/1/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import SwiftUI

struct Home: View {
    
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var routeController: RouteController
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State private var counter = 0
    @State var showOnboardingSheet = false
    @State var timeOfDay = "default"
    @State var menuBarTitle = "Linkbus"
    @State var initial = true
    @State var lastRefreshTime = ""
    @State var greeting = "Linkbus"
    
    @State var showingChangeDate = false
    
    
    var calendarButton: some View {
        Button(action: { self.showingChangeDate.toggle() }) {
            Image(systemName: "calendar")
                .imageScale(.large)
                .accessibility(label: Text("Change Date"))
                .padding()
        }
    }
    
    // init removes seperator/dividers from list, in future maybe use scrollview
    init() {
        self.routeController = RouteController()
        
        //UINavigationBar.setAnimationsEnabled(true)
        UITableView.appearance().separatorStyle = .none

        //        UITableView.appearance().backgroundColor = (colorScheme == .dark ? .white : .black)
        //        UITableViewCell.appearance().backgroundColor = .clear
        //        UINavigationBar.appearance().backgroundColor = (colorScheme == .dark ? .white : .black)
        //        print(colorScheme)

        let time = Date()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        //self.lastRefreshTime = timeFormatter.string(from: time)
        _lastRefreshTime = State(initialValue: timeFormatter.string(from: time))
    }
    
    var body: some View {
            NavigationView {
//                if(routeController.initalWebRequestFinished) {
                    if #available(iOS 14.0, *) { // iOS 14
                        ScrollView {
                            AlertList(routeController: routeController)
                            if !self.routeController.dateIsChanged {
                                RouteList(routeController: routeController)
                            }
                        }
                        .padding(.top, 0.3) // !! FIXES THE WEIRD NAVIGATION BAR GRAPHICAL GLITCHES WITH SCROLLVIEW IN NAVVIEW
                        .navigationBarTitle(self.menuBarTitle)
                        //.background((colorScheme == .dark ? Color(UIColor.systemBackground) : Color(UIColor.systemGray6)))
                        .navigationBarItems(trailing: calendarButton)
                    } else { // iOS 13
                        List {
                            AlertList(routeController: routeController)
                            if !self.routeController.dateIsChanged {
                                RouteList(routeController: routeController)
                            }
                        }
                        .transition(.opacity)
                        .animation(.default)
                        .navigationBarTitle(self.menuBarTitle)
                        //.transition(.opacity)
                        //.background((colorScheme == .dark ? Color(UIColor.systemBackground) : Color(UIColor.systemGray6)))
                        .navigationBarItems(trailing: calendarButton)
                    }
//                } else {
//                    VStack() {
////                        Text("Loading")
//                        ActivityIndicator(isAnimating: .constant(true), style: .large)
//                    }
//                    .navigationBarTitle(self.menuBarTitle)
//                    Spacer() // Makes the alerts and routes animate in from bottom
                }
//            }
            .onAppear {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let isFirstLaunch = appDelegate.isFirstLaunch()
                print(isFirstLaunch)
                if (isFirstLaunch) {
                    self.showOnboardingSheet = true
                } else {
                    self.showOnboardingSheet = false // change this to true while debugging OnboardingSheet
                    print("isFirstLaunch: ", showOnboardingSheet)
                }
            }
            .sheet(isPresented: $showOnboardingSheet) {
                OnboardingView()
            }
            // .hoverEffect(.lift)
            .onReceive(timer) { time in
                if self.counter >= 1 {
                    // Online Status
                    titleOnlineStatus(self: self, routeController: self.routeController)
                    // Greeting
                    titleGreeting(self: self)
                }
                self.counter += 1
                // Auto refresh
                autoRefreshData(self: self)
            }
            .sheet(isPresented: $showingChangeDate, onDismiss: {
                self.routeController.exitChangeDate()
            }) {
                ChangeDate(routeController: routeController)
            }
    }
}

struct ActivityIndicator: UIViewRepresentable {
    @Binding var isAnimating: Bool
    let style: UIActivityIndicatorView.Style
    func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
        return UIActivityIndicatorView(style: style)
    }
    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}

func titleOnlineStatus(self: Home, routeController: RouteController) {
    // print("online status: " + routeController.deviceOnlineStatus)
    if routeController.deviceOnlineStatus == "offline" {
        self.menuBarTitle = "Offline"
    }
    else if (routeController.deviceOnlineStatus == "online" || routeController.deviceOnlineStatus == "back online") {
        self.menuBarTitle = self.greeting
    }
}

func titleGreeting(self: Home) {
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
    
    if (timeOfDayChanged) {
        if (self.timeOfDay == "night") {
            let nightGreetings = ["Goodnight 😴", "Buenas noches 😴", "Goodnight 😴", "Goodnight 🌌", "Goodnight 😴"]
            let randomGreeting = nightGreetings.randomElement()
            self.greeting = randomGreeting!
        } else if (self.timeOfDay == "morning") {
            if (component.weekday == 2) { // if Monday
                let morningGreetings = ["Good morning 🌅", "Bonjour 🌅", "Happy Monday 🌅", "Happy Monday 🌅", "Happy Monday 🌅", "Good morning 🌅", "Good morning 🌅", "Good morning 🌅", "Buenos días 🌅"]
                let randomGreeting = morningGreetings.randomElement()
                self.greeting = randomGreeting!
            } else if (component.weekday == 6) {
                let morningGreetings = ["Good morning 🌅", "Bonjour 🌅", "Happy Friday 🌅", "Happy Friday 🌅", "Happy Friday 🌅", "Good morning 🌅", "Good morning 🌅", "Good morning 🌅", "Buenos días 🌅"]
                let randomGreeting = morningGreetings.randomElement()
                self.greeting = randomGreeting!
            } else {
                let morningGreetings = ["Good morning 🌅", "Bonjour 🌅", "Good morning 🌅", "Good morning 🌅", "Good morning 🌅", "Buenos días 🌅"]
                let randomGreeting = morningGreetings.randomElement()
                self.greeting = randomGreeting!
            }
        } else if (self.timeOfDay == "afternoon") {
            self.greeting = "Good afternoon ☀️"
        } else if (self.timeOfDay == "evening") { // < 24 , self.timeOfDay = evening
            let eveningGreetings = ["Good evening 🌙", "Good evening 🌙", "Good evening 🌙", "Good evening 🌙"]
            let randomGreeting = eveningGreetings.randomElement()
            self.greeting = randomGreeting!
        }
    }
}

func autoRefreshData(self: Home) {
    let time = Date()
    let timeFormatter = DateFormatter()
    timeFormatter.dateFormat = "HH:mm"
    let currentTime = timeFormatter.string(from: time)
//                print("last ref: " + self.lastRefreshTime)
//                print("current time: " + currentTime)
//                print("local desc: " + routeController.localizedDescription)
    if self.lastRefreshTime != currentTime {
        print("Refreshing data")
        self.routeController.webRequest()
        self.lastRefreshTime = currentTime
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
