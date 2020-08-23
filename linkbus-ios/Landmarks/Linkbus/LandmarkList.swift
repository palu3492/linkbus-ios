/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A view showing a list of landmarks.
*/

import SwiftUI

struct LandmarkList: View {
    var body: some View {
        NavigationView {
            List(routeData) { route in
                NavigationLink(destination: LandmarkDetail(route: route)) {
                    ProductCard(title: "Gorecki to Sexton", description: "College of Saint Benedict", image: Image("Smoothie_Bowl"), price: 15.00, peopleCount: 2, ingredientCount: 2, category: "5 minutes", buttonHandler: nil)
                }
                .onAppear {
                    let networkController = NetworkController()
                    networkController.loadLinkbusApi(completionHandler: <#(ApiBusSchedule) -> Void#>)
                    networkController.loadCsbsjuApi(completionHandler: <#(ApiBusSchedule) -> Void#>)
                }
            }
            .navigationBarTitle(Text("Landmarks"))
        }
    }
}

struct LandmarkList_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(["iPhone XS Max"], id: \.self) { deviceName in
            LandmarkList()
                .previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName(deviceName)
        }
    }
}
