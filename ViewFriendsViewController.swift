//
//  ViewFriendsViewController.swift
//  All Aboard
//
//  Created by Ian on 2/23/15.
//  Copyright (c) 2015 Nick Martinson. All rights reserved.
//

import Foundation
import UIKit

/******************************************************************************************
*   This class is responsible for showing a users friends list
******************************************************************************************/
class ViewFriendsViewController: UIViewController {
    
    @IBOutlet weak var friendsTableView: UITableView!
    
    @IBAction func backButtonHit(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    var friendsL:[User] = []

    /******************************************************************************************
    *   Gets the users friends list from the network.
    ******************************************************************************************/
    override func viewDidLoad() {
        BluemixCommunication().getFriendsList(UserPreferences().getGUID() )
        {
            (results: [User]) in
            self.friendsL = results
            self.friendsTableView.reloadData()
        }
        
    }
    
    /******************************************************************************************
    *   Displays each friend in a table view cell
    ******************************************************************************************/
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        //creating cell for table view.
        let cell = self.friendsTableView.dequeueReusableCellWithIdentifier("friendCell") as! ViewFriendsTableViewCell
        cell.nameLabel.text = friendsL[indexPath.row].realname as? String
        cell.setProfilePicture(friendsL[indexPath.row].userid as String)
        
        //adds label to the cell
//        cell.textLabel?.text = friendsL[indexPath.row].realname
//        cell.textLabel!.text! = friend["username"]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendsL.count
    }

    /******************************************************************************************
    *   Sets the height of each table view cell
    ******************************************************************************************/
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 61
    }
}