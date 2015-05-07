//
//  NotificationCell.swift
//  All Aboard
//
//  Created by Nick Martinson on 3/5/15.
//  Copyright (c) 2015 Nick Martinson. All rights reserved.
//

import Foundation

/******************************************************************************************
*   This class is an extension of UITableViewCell that is used to
******************************************************************************************/
class NotificationCell: UITableViewCell
{
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var descriptionText: UILabel!
    @IBOutlet weak var dateText: UILabel!
}