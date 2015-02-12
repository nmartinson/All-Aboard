//
//  ViewEventController.swift
//  All Aboard
//
//  Created by Nick Martinson on 2/8/15.
//  Copyright (c) 2015 Nick Martinson. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class ViewEventController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate
{
    
    let locationManager  = CLLocationManager()
    @IBOutlet weak var mapView: GMSMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        mapView.settings.compassButton = true
        if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse
        {
            locationManager.startUpdatingLocation()
            mapView.myLocationEnabled = true
            mapView.settings.myLocationButton = true
        }
    }
    
    /******************************************************************************************
    *
    ******************************************************************************************/
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus)
    {
        if status == .AuthorizedWhenInUse
        {
            locationManager.startUpdatingLocation()
            mapView.myLocationEnabled = true
            mapView.settings.myLocationButton = true
        }
    }
    
    /******************************************************************************************
    *
    ******************************************************************************************/
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!)
    {
        
        if let location = locations.first as? CLLocation{
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            locationManager.stopUpdatingLocation()
            //            fetchNearbyPlaces(location.coordinate)
        }
    }
    
    @IBAction func backButtonPressed(sender: AnyObject)
    {
        dismissViewControllerAnimated(true, completion: { () -> Void in })
    }
    
}