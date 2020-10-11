/*
 See LICENSE folder for this sample’s licensing information.
 
 Abstract:
 A view showing a list of landmarks.
 */

import SwiftUI
import Foundation
import Combine

struct RouteList: View {
    
    var routes: [LbRoute]
    
    init(routes: [LbRoute]){
        // routeController: RouteController
        self.routes = routes
//        print("Routes: ", routeController.lbBusSchedule.routes)
        print("RouteList init()")
        print("\(self.routes.count) routes")
    }
    
    var body: some View {
        if(self.routes.count > 0) {
            VStack (alignment: .leading, spacing: 12) {
                ForEach(self.routes) { route in
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
        } else {
            Text("No routes")
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

//struct LandmarkList_Previews: PreviewProvider {
//    static var previews: some View {
//        ForEach(["iPhone XS Max"], id: \.self) { deviceName in
//            let routeController = RouteController()
//            RouteList(routeController: routeController)
//                .previewDevice(PreviewDevice(rawValue: deviceName))
//                .previewDisplayName(deviceName)
//        }
//    }
//}
