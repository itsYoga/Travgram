//
//  CustomMapView.swift
//  Travgram
//
//  Created by Jesse Liang on 2025/1/4.
//


import SwiftUI
import MapKit
import TipKit

struct CustomMapView: UIViewRepresentable {
    @Binding var region: MKCoordinateRegion
    @Binding var annotation: MapAnnotationItem?
    var onMapItemSelected: (MKMapItem) -> Void

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.setRegion(region, animated: true)
        uiView.removeAnnotations(uiView.annotations)
        if let annotation = annotation {
            let pin = MKPointAnnotation()
            pin.coordinate = annotation.coordinate
            uiView.addAnnotation(pin)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: CustomMapView

        init(_ parent: CustomMapView) {
            self.parent = parent
        }

        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            guard let annotation = view.annotation else { return }
            let location = CLLocation(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)

            let request = MKLocalSearch.Request()
            request.region = mapView.region
            request.pointOfInterestFilter = .includingAll
            let search = MKLocalSearch(request: request)
            search.start { response, error in
                if let item = response?.mapItems.first {
                    self.parent.onMapItemSelected(item)
                }
            }
        }
    }
}
