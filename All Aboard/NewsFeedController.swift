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
    let data = [["Go to TCBs","Nick Martinson"],["Go to Short's","EEPUP"]]
    @IBOutlet weak var navBar: UINavigationItem!
    
    override func viewWillAppear(animated: Bool)
    {
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        navBar.title = "The Station"
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        performSegueWithIdentifier("eventSegue", sender: self)
    }
    

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return data.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell:NewsFeedTableViewCell? //= tableView.dequeueReusableCellWithIdentifier("newsCell") as? NewsFeedTableViewCell
        if cell == nil
        {
            tableView.registerNib(UINib(nibName: "NewsFeedCell", bundle: nil), forCellReuseIdentifier: "newsCell")
            cell = tableView.dequeueReusableCellWithIdentifier("newsCell") as? NewsFeedTableViewCell
        }
        
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        return 10
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: NewsFeedTableViewCell, forRowAtIndexPath indexPath: NSIndexPath)
    {
        cell.postedBy.text = data[indexPath.section][1]
        cell.eventImage.image = UIImage(named: "testImage")
        cell.locationLabel.text = "Seaman Center"
        cell.profilePicture.layer.cornerRadius = cell.profilePicture.frame.size.width/2
        cell.profilePicture.layer.borderWidth = 2
        cell.profilePicture.layer.borderColor = UIColor.whiteColor().CGColor
        cell.profilePicture.clipsToBounds = true
        let eepupID = "10153524130878066"
        var imageStr = "http://graph.facebook.com/\(eepupID)/picture?type=large"
        getLabelImage(imageStr, newImage: cell.profilePicture)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 200
    }
    
    
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