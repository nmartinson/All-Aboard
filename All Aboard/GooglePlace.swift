//
//  GooglePlace.swift
//  All Aboard
//
//  Created by Nick Martinson on 2/22/15.
//  Copyright (c) 2015 Nick Martinson. All rights reserved.
//

import Foundation
import UIKit

/******************************************************************************************
*   This represents a Google Place that is return from the autocomplete request
******************************************************************************************/
class GooglePlace:NSObject
{
    var name:String?
    var place_id:String?
    var identifier:String?
    var shortName:String?
    var streetName:String?
    var coordinate:CLLocationCoordinate2D?
    
    
    func placeFromJSON(rawJSON: JSON) -> [GooglePlace]
    {
        var places:[GooglePlace] = []
        for(var i = 0; i < rawJSON["predictions"].count; i++)
        {
            var place = GooglePlace()
            place.identifier = rawJSON["predictions"][i]["id"].stringValue
            place.name = rawJSON["predictions"][i]["description"].stringValue
            place.place_id = rawJSON["predictions"][i]["place_id"].stringValue
            place.shortName = rawJSON["predictions"][i]["terms"][0]["value"].stringValue
            place.streetName = rawJSON["predictions"][i]["terms"][1]["value"].stringValue
            places.append(place)
        }
        return places
    }
}