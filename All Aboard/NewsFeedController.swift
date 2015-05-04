//
//  TableViewController.swift
//  All Aboard
//
//  Created by Nick Martinson on 1/28/15.
//  Copyright (c) 2015 Nick Martinson. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

/******************************************************************************************
*   
******************************************************************************************/
extension Alamofire.Request
{
    class func imageResponseSerializer() -> Serializer{
        return { request, response, data in
            if( data == nil) {
                return (nil,nil)
            }
            let image = UIImage(data: data!, scale: UIScreen.mainScreen().scale)
            
            return (image, nil)
        }
    }
    
    func responseImage(completionHandler: (NSURLRequest, NSHTTPURLResponse?, UIImage?, NSError?) -> Void) -> Self{
        return response(serializer: Request.imageResponseSerializer(), completionHandler: { (request, response, image, error) in
            completionHandler(request, response, image as? UIImage, error)
        })
    }
}


class NewsFeedController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    @IBOutlet weak var navBar: UINavigationItem!
    @IBOutlet weak var tableView: UITableView!
    
    // Properties to send to Event Controller
    var imageOfSelectedCell: UIImage?
    var hostedByName = ""
    var eventLocation = ""
    var coordinates:CLLocationCoordinate2D?
    var selectedCellIndex = 0
    var events:[Event] = []
    var cachedPhotos = [String:UIImage]()

    
    /******************************************************************************************
    *   Configures the slide to reveal menu.
    *   Sets the navbar title
    *   Gets the recent events
    ******************************************************************************************/
    override func viewWillAppear(animated: Bool)
    {
        cachedPhotos.removeAll(keepCapacity: false)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        navBar.title = "The Station"
        BluemixCommunication().getRecentEvents(15)
        {
            (results: [Event]) in
            self.events = results
            self.tableView.reloadData()
        }
        println(UserPreferences().getGUID())
        
        BluemixCommunication().getUserInviteList(UserPreferences().getGUID())
        {
            (events: [Event]) in
            (self.tabBarController!.tabBar.items![3] as! UITabBarItem).badgeValue = "\(events.count)"
        }
    }

    override func viewDidDisappear(animated: Bool)
    {
//        AWSS3TransferManager.defaultS3TransferManager().cancelAll()
    }
    
    /******************************************************************************************
    *   This passes the previously retrieved event info to the next view controller
    ******************************************************************************************/
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        let navController = segue.destinationViewController as! UINavigationController
        let controller = navController.viewControllers.first as! ViewEventController
        controller.event = events[selectedCellIndex]
    }
    
    
    /******************************************************************************************
    *   When a cell is selected, this method grabs the information contained in that cell so
    *   that it can be passed to the next view and prevvent another network call to get the data.
    ******************************************************************************************/
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! NewsFeedTableViewCell
        imageOfSelectedCell = cell.profilePicture.image
        hostedByName = cell.postedBy.text!
        eventLocation = cell.locationLabel.text!
        selectedCellIndex = indexPath.section
        
        performSegueWithIdentifier("eventSegue", sender: self)
        cell.selected = false
        cell.highlighted = false
    }
    
    /******************************************************************************************
    *   Set each section as having 1 row
    ******************************************************************************************/
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
    
    /******************************************************************************************
    *
    ******************************************************************************************/
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return events.count//data.count
    }

    /******************************************************************************************
    *   Dequeues the custom reusable cell that will display in the tableview
    ******************************************************************************************/
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell:NewsFeedTableViewCell?
        if cell == nil
        {
            tableView.registerNib(UINib(nibName: "NewsFeedCell", bundle: nil), forCellReuseIdentifier: "newsCell")
            cell = tableView.dequeueReusableCellWithIdentifier("newsCell") as? NewsFeedTableViewCell
        }
        
        return cell!
    }
    
    /******************************************************************************************
    *
    ******************************************************************************************/
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        return 10
    }
    
    /******************************************************************************************
    *   Configures the cell that is about to be displayed
    ******************************************************************************************/
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath)
    {
        let key = "Cell\(indexPath.section)"
        if cachedPhotos[key] != nil
        {
            (cell as! NewsFeedTableViewCell).profilePicture.image = cachedPhotos[key]
        }
        else
        {
            AWShelper().downloadThumbnailImageFromS3("profilePictures", file: self.events[indexPath.section].EventHostID as? String, photoNumber: nil)
            {
                (image: UIImage?) in
                self.cachedPhotos[key] = image!
                (cell as! NewsFeedTableViewCell).profilePicture.image = image
            }
            
        }
        (cell as! NewsFeedTableViewCell).postedBy.text = events[indexPath.section].EventHostName as? String
        (cell as! NewsFeedTableViewCell).eventImage.image = UIImage(named: "billiards")
        (cell as! NewsFeedTableViewCell).locationLabel.text = events[indexPath.section].EventName as? String
        (cell as! NewsFeedTableViewCell).profilePicture.layer.cornerRadius = (cell as! NewsFeedTableViewCell).profilePicture.frame.size.width/2
        (cell as! NewsFeedTableViewCell).profilePicture.layer.borderWidth = 2
        (cell as! NewsFeedTableViewCell).profilePicture.layer.borderColor = UIColor.whiteColor().CGColor
        (cell as! NewsFeedTableViewCell).profilePicture.clipsToBounds = true
    }
    
    /******************************************************************************************
    *   Sets the height of the cell
    ******************************************************************************************/
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 200
    }
    
    
    /******************************************************************************************
    *   Configure the swipe right for the hidden menu
    ******************************************************************************************/
    @IBAction func revealButtonPressed(sender: AnyObject)
    {
        revealViewController().revealToggle(sender)
    }
}