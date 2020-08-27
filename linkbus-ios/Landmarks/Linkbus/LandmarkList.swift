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
    
    var alertPresented: Bool
    
    // init removes seperator/dividers from list, in future maybe use scrollview
    init() {
        UITableView.appearance().separatorStyle = .none
        self.alertPresented = false
    }

    var body: some View {
        NavigationView {
            List() {
                AlertCard()
                ForEach(routeController.lbBusSchedule.routes) { route in
                ProductCard(title: route.title, description: route.originLocation, image: Image("Smoothie_Bowl"), price: 15.00, peopleCount: 2, ingredientCount: 2, category: "5 minutes", route: route, buttonHandler: nil)
                }
                }
            .navigationBarTitle("Good night. 🌙 ")
//            List(routeController.lbBusSchedule.routes) { route in
//                VStack (alignment: .leading) {
//                    Text(route.title)
//                        .font(.system(size: 11))
//                        .foregroundColor(Color.gray)
//                }
//            }
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
