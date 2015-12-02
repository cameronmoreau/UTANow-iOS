//
//  MapViewController.swift
//  UTANow
//
//  Created by Cameron Moreau on 12/2/15.
//  Copyright © 2015 Mobi. All rights reserved.
//

import UIKit
import Mapbox

class MapViewController: UIViewController, MGLMapViewDelegate {
    
    @IBOutlet weak var mapView: MGLMapView!
    
    var markerPoint: CLLocationCoordinate2D?
    var markerTitle: String?
    
    @IBAction func cancelAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        //Place marker if send in by previous view
        if let point = markerPoint {
            let marker = MGLPointAnnotation()
            marker.coordinate = point
            marker.title = markerTitle
            mapView.addAnnotation(marker)
            
            //Zoom on marker
            mapView.setCenterCoordinate(point, zoomLevel: 17, animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Use default marker
    func mapView(mapView: MGLMapView, imageForAnnotation annotation: MGLAnnotation) -> MGLAnnotationImage? {
        return nil
    }
    
    //Show annotation text
    func mapView(mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }

}
