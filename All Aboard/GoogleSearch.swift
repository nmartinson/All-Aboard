//
//  GoogleSearch.swift
//  All Aboard
//
//  Created by Nick Martinson on 2/22/15.
//  Copyright (c) 2015 Nick Martinson. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class GoogleSearch:NSObject
{
    
    
    func googleURLString()
    {
        var url = "https://maps.googleapis.com/maps/api/place/autocomplete/json?key=\(APIkeys.googlePlacesKey)"
    }
    
    func fetchPlaces(searchString: String, coordinates: CLLocationCoordinate2D, completion:(places: [GooglePlace]) -> Void)
    {
        
//        let location = "41.6667,91.5333"
        let location = "\(coordinates.latitude),\(coordinates.longitude)"
        var url = "https://maps.googleapis.com/maps/api/place/autocomplete/json?key=\(APIkeys.googlePlacesKey)&input=\(searchString)&location=\(location)"
        
        Alamofire.request(.GET, url, parameters: nil ).responseJSON { (_, response, rawJSON,_) -> Void in
            
        
            var places:[GooglePlace] = []
            let data = JSON(rawJSON!)
            if data["status"].stringValue == "INVALID_REQUEST"
            {
                println("NO RESULTS")
                places = []
            }
            else if data["status"].stringValue == "OK"
            {
                println("OK")
                places = GooglePlace().placeFromJSON(data)
                
            }
            completion(places: places)
        }
    }
    
    func fetchPlaceDetails(placeID:String, completion:(place: GooglePlaceDetail) -> Void)
    {
        var url = "https://maps.googleapis.com/maps/api/place/details/json?key=\(APIkeys.googlePlacesKey)&placeid=\(placeID)"
        Alamofire.request(.GET, url, parameters: nil ).responseJSON { (_, response, rawJSON,_) -> Void in
            
            let data = JSON(rawJSON!)
            var placeDetail = GooglePlaceDetail().placeDetailFromJSON(data)
            completion(place: placeDetail)
        }

    }
    

}