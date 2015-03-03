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
    let data = [["Go to TCBs!","Nick Martinson", "10203626718697502","billiards"],["Go to Short's","Ian Brauer", "10153524130878066","burger"]]
    @IBOutlet weak var navBar: UINavigationItem!
    @IBOutlet weak var tableView: UITableView!
    
    // Properties to send to Event Controller
    var imageOfSelectedCell: UIImage?
    var hostedByName = ""
    var eventLocation = ""
    var coordinates:CLLocationCoordinate2D?
    var selectedCellIndex = 0
    var events:[Event] = []

    
    /******************************************************************************************
    *   Configures the slide to reveal menu.
    *   Sets the navbar title
    *   Gets the recent events
    ******************************************************************************************/
    override func viewWillAppear(animated: Bool)
    {
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        navBar.title = "The Station"
        BluemixCommunication().getRecentEvents(10)
        {
            (results: [Event]) in
            self.events = results
            self.tableView.reloadData()
        }
        
        BluemixCommunication().getUserInfoByID(UserPreferences().getGUID())
        {
            (user: Dictionary<String,AnyObject>?) in
        }
        
    }

    
    /******************************************************************************************
    *   This passes the previously retrieved event info to the next view controller
    ******************************************************************************************/
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        let navController = segue.destinationViewController as UINavigationController
        let controller = navController.viewControllers.first as ViewEventController
//        controller.hostedByPic = imageOfSelectedCell
//        controller.hostedByText = hostedByName
//        controller.locationText = eventLocation
//        controller.event = events[selectedCellIndex]
        controller.event = events[selectedCellIndex]
    }
    
    
    /******************************************************************************************
    *   When a cell is selected, this method grabs the information contained in that cell so
    *   that it can be passed to the next view and prevvent another network call to get the data.
    ******************************************************************************************/
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as NewsFeedTableViewCell
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
    func tableView(tableView: UITableView, willDisplayCell cell: NewsFeedTableViewCell, forRowAtIndexPath indexPath: NSIndexPath)
    {
        cell.postedBy.text = events[indexPath.section].EventHostName
        cell.eventImage.image = UIImage(named: data[0][3])
        cell.locationLabel.text = events[indexPath.section].EventName
//        cell.postedBy.text = data[indexPath.section][1]
//        cell.eventImage.image = UIImage(named: data[indexPath.section][3])
//        cell.locationLabel.text = data[indexPath.section][0]
        cell.profilePicture.layer.cornerRadius = cell.profilePicture.frame.size.width/2
        cell.profilePicture.layer.borderWidth = 2
        cell.profilePicture.layer.borderColor = UIColor.whiteColor().CGColor
        cell.profilePicture.clipsToBounds = true
        let id = data[0][2]
        var imageStr = "http://graph.facebook.com/\(id)/picture?type=large"
        getLabelImage(imageStr, newImage: cell.profilePicture)
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
    
    
    /******************************************************************************************
    * Allows for placing an image in a dynamically created imageview
    ******************************************************************************************/
    func getLabelImage(imageStr: String, newImage: UIImageView)
    {
        Alamofire.request(.GET,imageStr).responseImage({ (request, _, image, error) -> Void in
            if error == nil && image != nil{
                newImage.image = image
            }
        })
    }
}