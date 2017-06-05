//
//  mapViewExt.swift
//  Bird Watching
//
//  Created by Sten Golds on 7/25/16.
//  Copyright © 2016 Sten Golds. All rights reserved.
//

import Foundation
import MapKit

extension socialListVC: MKMapViewDelegate {
    
    /**
     * @name mapView - viewFor annotation
     * @desc provides map with info needed to display annotation, code adapted from code on www.raywenderlich.com
     * @param MKMapView mapView - the mapView
     * @param MKAnnotation annotation - annotation passed in
     * @return MKAnnotationView - the annotation view with our info
     * or nil - if annotation couldn't be cast as BirdMapAnnotation
     */
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? BirdMapAnnotation {
            let identifier = "pin"
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
                as? MKPinAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView
                
                //following if statement will make the annotation pin green if it is not flagged
                //and make the pin red if it is flagged (users may flag posts if they consider the sighting false)
                //this allows users to still see sightings that may be false, but gives them a warning beforehand
                if(annotation.isGreen) {
                    view.pinTintColor = greenForPin
                } else {
                    view.pinTintColor = redForPin
                }
            }
            return view
        }
        return nil
    }
}
