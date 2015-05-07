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

/******************************************************************************************
*   This class is used for communicating with the Google Places API
******************************************************************************************/
class GoogleSearch:NSObject
{

    /******************************************************************************************
    *   Returns the google places route to make a network call to
    ******************************************************************************************/
    func googleURLString()
    {
        var url = "https://maps.googleapis.com/maps/api/place/autocomplete/json?key=\(APIkeys.googlePlacesKey)"
    }
    
    /******************************************************************************************
    *   This function makes a network call to Google Places to give autocomplete suggestions
    ******************************************************************************************/
    func fetchPlaces(searchString: String, coordinates: CLLocationCoordinate2D, completion:(places: [GooglePlace]) -> Void)
    {
        let location = "\(coordinates.latitude),\(coordinates.longitude)"
        var url = "https://maps.googleapis.com/maps/api/place/autocomplete/json?key=\(APIkeys.googlePlacesKey)&input=\(searchString)&location=\(location)"
        
        Alamofire.request(.GET, url, parameters: nil ).responseJSON { (_, response, rawJSON,_) -> Void in
            
        
            var places:[GooglePlace] = []
            let data = JSON(rawJSON!)
            if data["status"].stringValue == "INVALID_REQUEST"
            {
                places = []
            }
            else if data["status"].stringValue == "OK"
            {
                places = GooglePlace().placeFromJSON(data)
                
            }
            completion(places: places)
        }
    }
    
    /******************************************************************************************
    *   This function makes a network call to Google Places to get place details
    ******************************************************************************************/
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