//
//  GooglePlace.swift
//  All Aboard
//
//  Created by Nick Martinson on 2/22/15.
//  Copyright (c) 2015 Nick Martinson. All rights reserved.
//

import Foundation
import UIKit

class GooglePlace:NSObject
{
    var name:String?
    var reference:String?
    var identifier:String?
    
    
    func placeFromJSON(rawJSON: JSON) -> [GooglePlace]
    {
        var places:[GooglePlace] = []
        for(var i = 0; i < rawJSON.count; i++)
        {
            var place = GooglePlace()
            place.identifier = rawJSON["predictions"][i]["id"].stringValue
            place.name = rawJSON["predictions"][i]["description"].stringValue
            place.reference = rawJSON["predictions"][i]["reference"].stringValue
            places.append(place)
        }
        return places
    }
}