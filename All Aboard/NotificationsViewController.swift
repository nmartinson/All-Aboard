//
//  NotificationsViewController.swift
//  All Aboard
//
//  Created by Nick Martinson on 3/5/15.
//  Copyright (c) 2015 Nick Martinson. All rights reserved.
//

import Foundation
import UIKit

class NotificationsViewController:UIViewController, UITableViewDelegate, UITableViewDataSource
{
    var events:[Event] = []

    @IBOutlet weak var notificationTab: UITabBarItem!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(true)
        BluemixCommunication().getUserInviteList(UserPreferences().getGUID())
        {
            (events: [Event]) in
            self.events = events
            self.notificationTab.badgeValue = "\(self.events.count)"
            self.tableView.reloadData()
        }

    }
    
    /******************************************************************************************
    *
    ******************************************************************************************/
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell:NotificationCell?
        if cell == nil
        {
            tableView.registerNib(UINib(nibName: "NotificationCell", bundle: nil), forCellReuseIdentifier: "notificationCell")
            cell = tableView.dequeueReusableCellWithIdentifier("notificationCell") as? NotificationCell
        }
        return cell!
    }
    
    /******************************************************************************************
    *
    ******************************************************************************************/
    func tableView(tableView: UITableView, willDisplayCell cell: NotificationCell, forRowAtIndexPath indexPath: NSIndexPath)
    {
        cell.descriptionText.text = "\(events[indexPath.row].EventHostName!) has invited you to \(events[indexPath.row].EventName!)"
        cell.dateText.text = Helper().formatDateString(events[indexPath.row].EventStartDate!)
        let eepupID = "10153524130878066"
        var imageStr = "http://graph.facebook.com/\(eepupID)/picture?type=normal"
        Helper().getLabelImage(imageStr, newImage: cell.profilePicture)
    }
    
    /******************************************************************************************
    *
    ******************************************************************************************/
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("viewEvent") as ViewEventController
        vc.event = events[indexPath.row]
        vc.acceptedInvite = false
        let navBar = UINavigationBar(frame: CGRectMake(0, UIApplication.sharedApplication().statusBarFrame.height, UIScreen.mainScreen().bounds.width, 44))
        let backButton = UIBarButtonItem(title: "Back", style: .Plain, target: self, action: "handleBack")
        let barItem = UINavigationItem(title: "Event")
        barItem.leftBarButtonItem = backButton
        
        navBar.items = [barItem]
        vc.view.addSubview(navBar)
        
        presentViewController(vc, animated: true, completion: nil)
    }
    
    func handleBack()
    {
        dismissViewControllerAnimated(true, completion: nil)
    }
    /******************************************************************************************
    *
    ******************************************************************************************/
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return events.count
    }
    
    /******************************************************************************************
    *
    ******************************************************************************************/
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 70
    }
    
    /******************************************************************************************
    *
    ******************************************************************************************/
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    
}