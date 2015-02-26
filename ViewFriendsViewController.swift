//
//  ViewFriendsViewController.swift
//  All Aboard
//
//  Created by Ian on 2/23/15.
//  Copyright (c) 2015 Nick Martinson. All rights reserved.
//

import Foundation
import UIKit

class ViewFriendsViewController: UIViewController {
    
    @IBOutlet weak var friendsTableView: UITableView!
    
    var friendsL:[Dictionary<String,AnyObject>?] = []

    override func viewDidLoad() {
        BluemixCommunication().getFriendsList(UserPreferences().getGUID() )
        {
            (results: [Dictionary<String,AnyObject>?]) in
            self.friendsL = results
        }
        
        println(self.friendsL)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        //creating cell for table view.
        let cell = self.friendsTableView.dequeueReusableCellWithIdentifier("friendCell", forIndexPath: indexPath) as UITableViewCell
        
        var friend:Dictionary<String,AnyObject>
        
        //counting how many candies appear in index path
        friend = self.friendsL[indexPath.row]!
        
        //adds label to the cell
        cell.textLabel?.text = friend["username"]?.value
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendsL.count
    }

    
}