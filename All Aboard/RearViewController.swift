//
//  RearViewController.swift
//  OnTap
//
//  Created by Nick Martinson on 1/2/15.
//  Copyright (c) 2015 Nick Martinson. All rights reserved.
//

import Foundation
import UIKit

class RearViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate, FBLoginViewDelegate
{
    
    let menuItems = ["All Aboard", "Login"]

    
    /******************************************************************************************
    *
    ******************************************************************************************/
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var item = menuItems[indexPath.row]
        var cell = tableView.dequeueReusableCellWithIdentifier(item) as UITableViewCell
        return cell
    }
    
    override func tableView(tableView: UITableView, didHighlightRowAtIndexPath indexPath: NSIndexPath)
    {
        tableView.cellForRowAtIndexPath(indexPath)?.textLabel?.textColor = UIColor.blackColor()
        tableView.cellForRowAtIndexPath(indexPath)?.backgroundColor = UIColor.lightGrayColor()
    }
    
    /******************************************************************************************
    *
    ******************************************************************************************/
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        tableView.cellForRowAtIndexPath(indexPath)?.highlighted = false
        tableView.cellForRowAtIndexPath(indexPath)?.selected = false
        tableView.cellForRowAtIndexPath(indexPath)?.textLabel?.textColor = UIColor.lightGrayColor()
        tableView.cellForRowAtIndexPath(indexPath)?.backgroundColor = UIColor.blackColor()
        switch(indexPath.row)
        {
        case 1:
            var i = 0
        case 2:
            var i = 0
        case 3:
            var i = 9
        default:
            break
        }
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        println("deselected")
    }
    /******************************************************************************************
    *
    ******************************************************************************************/
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return menuItems.count
    }
    
    /******************************************************************************************
    *
    ******************************************************************************************/
    func loginViewShowingLoggedOutUser(loginView: FBLoginView!)
    {
//        var viewController = LoginViewController()
        var storyboard = UIStoryboard(name: "Main", bundle: nil)
        var viewController = storyboard.instantiateViewControllerWithIdentifier("LoginViewController") as LoginViewController
        
        presentViewController(viewController, animated: true) { () -> Void in }
        
    }
    
    /******************************************************************************************
    *
    ******************************************************************************************/
    func loginViewShowingLoggedInUser(loginView: FBLoginView!)
    {
        var friendsRequest = FBRequest.requestForMyFriends()
        friendsRequest.startWithCompletionHandler { (connection:FBRequestConnection!, result:AnyObject!, error:NSError!) -> Void in
            var resultDict = result as NSDictionary
            println("Result dic: \(resultDict)")
        }
    }
    
    
}
