//
//  GooglePlaceDetail.swift
//  All Aboard
//
//  Created by Nick Martinson on 2/23/15.
//  Copyright (c) 2015 Nick Martinson. All rights reserved.
//

import Foundation
import UIKit

/******************************************************************************************
*   This class represents a Google Place object that contains details about a specific place.
******************************************************************************************/
class GooglePlaceDetail:NSObject
{
    var name:String?
    var place_id:String?
    var identifier:String?
    var shortName:String?
    var streetName:String?
    var coordinates:CLLocationCoordinate2D?
    
    
    func placeDetailFromJSON(rawJSON: JSON) -> GooglePlaceDetail
    {
        var place = GooglePlaceDetail()
        let lat = rawJSON["result"]["geometry"]["location"]["lat"].floatValue
        let long = rawJSON["result"]["geometry"]["location"]["lng"].floatValue
        place.coordinates = CLLocationCoordinate2DMake(CLLocationDegrees(lat), CLLocationDegrees(long))
        println(place.coordinates)
        return place
    }
}