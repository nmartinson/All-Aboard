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
    
    var menuItems = ["All Aboard", "Login"]

    override func viewDidLoad() {
        let loginState = UserPreferences().loggedInState()
        if loginState
        {
            menuItems[1] = "standardLogOut"
        }
    }
    
    /******************************************************************************************
    *
    ******************************************************************************************/
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var item = menuItems[indexPath.row]
        var cell = tableView.dequeueReusableCellWithIdentifier(item) as! UITableViewCell
        if item == "standardLogOut"
        {
            cell.textLabel?.text = "Log out \(UserPreferences().getName())"
        }
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
        let identifier = tableView.cellForRowAtIndexPath(indexPath)?.reuseIdentifier!
        if identifier == "standardLogOut"
        {
            var storyboard = UIStoryboard(name: "Main", bundle: nil)
            var viewController = storyboard.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
            UserPreferences().loggedIn(false)
            
            presentViewController(viewController, animated: true) { () -> Void in }

        }

    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath)
    {
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
        println("logged out")
        if !UserPreferences().loggedInState()
        {
            var storyboard = UIStoryboard(name: "Main", bundle: nil)
            var viewController = storyboard.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
            
            presentViewController(viewController, animated: true) { () -> Void in }
        }
    }
    
    
}
