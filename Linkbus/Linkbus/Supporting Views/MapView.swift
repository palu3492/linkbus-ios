/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A view that hosts an `MKMapView`.
*/

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    var coordinate: CLLocationCoordinate2D

    func makeUIView(context: Context) -> MKMapView {
        MKMapView(frame: .zero)
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        uiView.setRegion(region, animated: false) // set to false to try to fix lag
        uiView.mapType = MKMapType.satelliteFlyover
        uiView.isZoomEnabled = false
        uiView.isScrollEnabled = false
        uiView.isPitchEnabled = false
        uiView.isRotateEnabled = false
        uiView.isUserInteractionEnabled = false
        uiView.showsUserLocation = false
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(coordinate: CLLocationCoordinate2D(latitude: 45.5606, longitude: -94.3221))
    }
}
