/*
 See LICENSE folder for this sample’s licensing information.
 
 Abstract:
 A view showing a list of landmarks.
 */

import SwiftUI
import Foundation
import Combine

struct LandmarkList: View {
    @ObservedObject var routeController = RouteController()
    var body: some View {
        NavigationView {
            List(routeController.apiBusSchedule.routes ?? []) { route in
                NavigationLink(destination: LandmarkDetail(route: route)) {
                    ProductCard(title: route.title!, description: route.title!, image: Image("Smoothie_Bowl"), price: 15.00, peopleCount: 2, ingredientCount: 2, category: "5 minutes", buttonHandler: nil)
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
            LandmarkList()
                .previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName(deviceName)
        }
    }
}
