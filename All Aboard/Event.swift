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
    var EventName:NSString?
    var EventLocation:NSString?
    var EventStartDate:NSDate?
    var EventCoordinates:CLLocationCoordinate2D?
    var EventHostID:NSString?
    var EventID:NSString?
    var EventHostName:NSString?
    var EventEndDate:NSDate?
    var EventInviteList:[String]?
    
    init()
    {
        
    }
    
    init(name:NSString, location:NSString, coordinates:CLLocationCoordinate2D, hostID:NSString, eventStartDate:NSDate, eventEndDate:NSDate)
    {
        EventName = name
        EventLocation = location
        EventStartDate = eventStartDate
        EventEndDate = eventEndDate
        EventHostID = hostID
        EventCoordinates = coordinates
    }
    
    
    
    init(name:NSString, location:NSString, coordinates:CLLocationCoordinate2D, hostID:NSString, eventStartDate: NSDate, eventID: NSString)
    {
        EventName = name
        EventLocation = location
        EventHostID = hostID
        EventCoordinates = coordinates
        EventStartDate = eventStartDate
        EventID = eventID
    }
 
    init(name:NSString, location:NSString, coordinates:CLLocationCoordinate2D, hostID:NSString, eventStartDate: NSDate, eventEndDate:NSDate, eventID: NSString, hostName: String, inviteList:[String])
    {
        EventName = name
        EventLocation = location
        EventHostID = hostID
        EventCoordinates = coordinates
        EventStartDate = eventStartDate
        EventID = eventID
        EventHostName = hostName
        EventInviteList = inviteList
        EventEndDate = eventEndDate
    }
}