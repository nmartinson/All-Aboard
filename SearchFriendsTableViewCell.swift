//
//  SearchFriendsTableViewCell.swift
//  All Aboard
//
//  Created by Nick Martinson on 3/1/15.
//  Copyright (c) 2015 Nick Martinson. All rights reserved.
//

import Foundation


class SearchFriendsTableViewCell: UITableViewCell
{
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addFriendButton: UIButton!
    var userID = ""
    
    
    @IBAction func addFriendButtonPressed(sender: AnyObject)
    {
        println(nameLabel.text)
    }
    
}