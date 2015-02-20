//
//  Event.swift
//  All Aboard
//
//  Created by Ian on 1/30/15.
//  Copyright (c) 2015 Nick Martinson. All rights reserved.
//

import Foundation
import UIKit



class Event {
    var EventName:NSString
    var EventLocation:NSString
    var EventDate:NSDate
    var EventCoordinates:CLLocationCoordinate2D?
    var EventHostID:NSString?
    var EventID:NSString?
    
    init(name:NSString, location:NSString, date:NSDate)
    {
        EventName = name
        EventLocation = location
        EventDate = date
    }
    
    
    
    init(name:NSString, location:NSString, coordinates:CLLocationCoordinate2D, hostID:NSString, date: NSDate, eventID: NSString)
    {
        EventName = name
        EventLocation = location
        EventHostID = hostID
        EventCoordinates = coordinates
        EventDate = date
        EventID = eventID
    }
    
}