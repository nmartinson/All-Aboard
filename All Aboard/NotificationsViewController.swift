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
    var cachedPhotos = [String:UIImage]()

    @IBOutlet weak var notificationTab: UITabBarItem!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(true)
        cachedPhotos.removeAll(keepCapacity: false)
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
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath)
    {
        let key = "Cell\(indexPath.row)"
        println(key)
        (cell as! NotificationCell).descriptionText.text = "\(events[indexPath.row].EventHostName!) has invited you to \(events[indexPath.row].EventName!)"
        (cell as! NotificationCell).dateText.text = Helper().formatDateString(events[indexPath.row].EventStartDate!)
        
        if cachedPhotos[key] != nil
        {
            (cell as! NotificationCell).profilePicture.image = cachedPhotos[key]
            println("Cached")
        }
        else
        {
            println("download")
            AWShelper().downloadThumbnailImageFromS3("profilePictures", file: self.events[indexPath.row].EventHostID as? String, photoNumber: nil)
            {
                (image: UIImage?) in
                self.cachedPhotos[key] = image!
                (cell as! NotificationCell).profilePicture.image = image
            }
            
        }
        
        
    }
    
    /******************************************************************************************
    *
    ******************************************************************************************/
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let navController = self.storyboard?.instantiateViewControllerWithIdentifier("EventNavController") as! UINavigationController
        let controller = navController.viewControllers.first as! ViewEventController
        controller.event = events[indexPath.row]
        controller.acceptedInvite = false
        controller.navigationItem.rightBarButtonItem = nil
        presentViewController(navController, animated: true, completion: nil)
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