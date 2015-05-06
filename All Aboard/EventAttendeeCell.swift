//
//  EventAttendeeCell.swift
//  All Aboard
//
//  Created by Nick Martinson on 3/27/15.
//  Copyright (c) 2015 Nick Martinson. All rights reserved.
//

import Foundation
import UIKit

/******************************************************************************************
*   This class is an extension of the UICollectionViewCell that is used to display the 
*   event attendees with an image and a name.
******************************************************************************************/
class EventAttendeeCell: UICollectionViewCell
{
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var attendeeName: UILabel!
}