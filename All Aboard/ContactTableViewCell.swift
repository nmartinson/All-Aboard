//
//  ContactTableViewCell.swift
//  All Aboard
//
//  Created by Nick Martinson on 2/22/15.
//  Copyright (c) 2015 Nick Martinson. All rights reserved.
//

import Foundation

class ContactTableViewCell: UITableViewCell
{
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addFriendButton: UIButton!
    
    @IBAction func addFriendButtonPressed(sender: AnyObject)
    {
        
        println(nameLabel.text!)
    }
}