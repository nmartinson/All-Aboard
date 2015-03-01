//
//  AddFriendsViewController.swift
//  All Aboard
//
//  Created by Nick Martinson on 2/22/15.
//  Copyright (c) 2015 Nick Martinson. All rights reserved.
//

import Foundation
import UIKit

class InviteFriendsToEventController: UIViewController, UITableViewDataSource, UITableViewDelegate, checkBoxCellDelegate
{
    @IBOutlet weak var tableView: UITableView!
    
    var people : [User] = []
    var selectedFriends:[String] = []
    
    /******************************************************************************************
    *
    ******************************************************************************************/
    override func viewDidLoad()
    {
        BluemixCommunication().getFriendsList(UserPreferences().getGUID())
        {
            (friends: [User]) in
            self.people = friends
            self.tableView.reloadData()
        }
    }
    
    /******************************************************************************************
    *
    ******************************************************************************************/
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell = tableView.dequeueReusableCellWithIdentifier("contactCell") as ContactTableViewCell
        cell.delegate = self
        cell.nameLabel.text = people[indexPath.row].realname
        cell.userID = people[indexPath.row].userid
        
        return cell
    }
    
    /******************************************************************************************
    *
    ******************************************************************************************/
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        
    }
    
    /******************************************************************************************
    *
    ******************************************************************************************/
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return people.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 61
    }
    /******************************************************************************************
    *
    ******************************************************************************************/
    @IBAction func backButtonPressed(sender: AnyObject)
    {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    /******************************************************************************************
    *   Gets called when a checkbox is selected
    ******************************************************************************************/
    func didSelectCheckbox(userID: String)
    {
        if contains(selectedFriends, userID)
        {
            for(var i = 0; i < selectedFriends.count; i++)
            {
                if selectedFriends[i] == userID
                {
                    selectedFriends.removeAtIndex(i)
                }
            }
            
        }
        else
        {
            selectedFriends.append(userID)
        }
    }



    
    
    
}