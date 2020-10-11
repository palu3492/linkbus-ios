//
//  HomeView.swift
//  Linkbus
//
//  Created by Alex Palumbo on 10/10/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var routeController = RouteController()
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var counter = 0
    
    @State private var menuBarTitle = "Linkbus"
    
    var calendarButton: some View {
        NavigationLink(destination: SelectDate(), isActive: $isActive) {
            Image(systemName: "calendar")
            .imageScale(.large)
            .padding()
        }
    }
    @State private var isActive: Bool = false
    
    init() {
        UINavigationBar.setAnimationsEnabled(true)
        UITableView.appearance().separatorStyle = .none
        print("HomeView init()")
        //        UITableView.appearance().backgroundColor = (colorScheme == .dark ? .white : .black)
        //        UITableViewCell.appearance().backgroundColor = .clear
        //        UINavigationBar.appearance().backgroundColor = (colorScheme == .dark ? .white : .black)
        //        print(colorScheme)
    }
    
    func setGreeting() -> Void {
        let currentDate = Date()
        let calendar = Calendar(identifier: .gregorian)
        let hour = calendar.component(.hour, from: currentDate)
    //    let component = calendar.dateComponents([.weekday], from: currentDate)
        let greetings: Array<String>
        
        if (hour < 6) {
            greetings = ["Goodnight 😴", "Buenas noches 😴", "Goodnight 😴", "Goodnight 😴"]
        }
        else if (hour < 12) {
    //        if (component.weekday == 2) { // if Monday
    //            self.greeting = "Happy Monday 🌅"
    //        }
    //        else if (component.weekday == 6) {
    //            self.greeting = "Happy Friday 🌅"
    //        }
    //        else {
            greetings = ["Good morning 🌅", "Bonjour 🌅", "Good morning 🌅", "Good morning 🌅"]
            
    //            }
        }
        else if (hour < 17) {
            greetings = ["Good afternoon ☀️"]
        }
        else { // < 24
            greetings = ["Good evening 🌙", "Buena noches 🌙", "Good evening 🌙", "Good evening 🌙"]
        }
        let randomGreeting = greetings.randomElement()
        let greeting = randomGreeting!
        self.menuBarTitle = greeting
    }
    
    var body: some View {
        
        NavigationView {
            if(self.routeController.lbBusSchedule.routes.count > 0) {
                List() {
                    // Render alert cards
                    AlertList(alerts: self.routeController.lbBusSchedule.alerts) // routeController: self.routeController
                    // Render route cards
                    RouteList(routes: self.routeController.lbBusSchedule.routes) // routeController: self.routeController
                    //.listRowBackground((colorScheme == .dark ? Color(UIColor.systemBackground) : Color(UIColor.systemGray6)))
                }
                    //.listRowBackground((colorScheme == .dark ? Color(UIColor.systemBackground) : Color(UIColor.systemGray6)))
                    //.background((colorScheme == .dark ? Color(UIColor.systemBackground) : Color(UIColor.systemGray6)))
                    // .navigationBarTitle(self.isActive ? "Back" : self.menuBarTitle)
                    .navigationBarTitle(self.menuBarTitle)
                    .navigationBarItems(trailing: calendarButton)
            } else {
                VStack() {
                    Text("Loading")
                    ActivityIndicator(isAnimating: .constant(true), style: .large)
                }
                .navigationBarTitle(self.menuBarTitle)
            }
        }
        .onReceive(timer) { time in
            if self.counter == 1 {
                setGreeting()
                self.timer.upstream.connect().cancel()
            }
            counter += 1
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

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
