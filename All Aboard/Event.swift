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
    init(name:NSString, location:NSString, date:NSDate) {
        EventName = name
        EventLocation = location
        EventDate = date
    }
}