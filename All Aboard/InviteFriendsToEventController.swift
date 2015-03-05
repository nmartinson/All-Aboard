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
    
    var people : [User] = []    // holds friends list
    var selectedFriends:[String] = []   // holds the 'checked friends'
    var currentEvent:Event?
    
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
        cell.indexPath = indexPath
        
        return cell
    }
    
    /******************************************************************************************
    *
    ******************************************************************************************/
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as ContactTableViewCell
        
        cell.addFriendButton.sendActionsForControlEvents(.TouchUpInside) // call button pressed method
        
//        if cell.checkBoxSelected == true
//        {
//            cell.highlighted = true
////            cell.selected = true
//        }
//        else
//        {
//            cell.highlighted = false
////            cell.selected = false
//        }
//        println("Selected")
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
    *
    ******************************************************************************************/
    @IBAction func createEventButtonPressed(sender: UIBarButtonItem)
    {
        
    }
    
    /******************************************************************************************
    *   Gets called when a checkbox is selected
    ******************************************************************************************/
    func didSelectCheckbox(userID: String, indexPath:NSIndexPath, selected:Bool)
    {
        if selected
        {
            (tableView.cellForRowAtIndexPath(indexPath) as ContactTableViewCell).setHighlighted(true, animated: true)
        }
        else
        {
            (tableView.cellForRowAtIndexPath(indexPath) as ContactTableViewCell).setHighlighted(false, animated: true)
        }
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
    
    /******************************************************************************************
    *
    ******************************************************************************************/
    @IBAction func createButtonPressed(sender: AnyObject)
    {
        if selectedFriends.count > 0
        {
            var selectedFriendsString = selectedFriends[0]
            for(var i = 1; i < selectedFriends.count; i++)
            {
                selectedFriendsString = selectedFriendsString + "," + selectedFriends[i]
            }
            let startDate = currentEvent!.EventStartDate!
            let startTimeStamp = Int((startDate.timeIntervalSince1970) * 1000)
            let endDate = currentEvent!.EventEndDate!
            let endTimeStamp = Int((endDate.timeIntervalSince1970) * 1000)
            
            let params = ["action":ACTIONCODES.NEW_EVENT, "title":currentEvent!.EventName!, "host":currentEvent!.EventHostID!, "lat":currentEvent!.EventCoordinates!.latitude, "lon":currentEvent!.EventCoordinates!.longitude, "startTime": startTimeStamp, "endTime": endTimeStamp, "inviteList": selectedFriendsString, "locationTitle": currentEvent!.EventLocation!]
            BluemixCommunication().createEvent(params)
            dismissViewControllerAnimated(true, completion: nil)
        }
    }


    
    
    
}