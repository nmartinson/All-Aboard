//
//  ViewController.swift
//  All Aboard
//
//  Created by Nick Martinson on 1/28/15.
//  Copyright (c) 2015 Nick Martinson. All rights reserved.
//

import UIKit
import Alamofire

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var profilePic: UIImageView!
    var events:[[Event]] = [[],[]]
    
    
    /******************************************************************************************
    *
    ******************************************************************************************/
    override func viewDidLoad() {
        let eepupID = "10153524130878066"
        var imageStr = "http://graph.facebook.com/\(eepupID)/picture?type=large"
        getLabelImage(imageStr, newImage: profilePic)
    }
    
    /******************************************************************************************
    *
    ******************************************************************************************/
    func getLabelImage(imageStr: String, newImage: UIImageView)
    {
        Alamofire.request(.GET,imageStr).responseImage({ (request, _, image, error) -> Void in
            if error == nil && image != nil{
                newImage.image = image
            }
        })
    }
    
    
    /******************************************************************************************
    *
    ******************************************************************************************/
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let  cell = tableView.dequeueReusableCellWithIdentifier("eventCell") as UITableViewCell
        return cell
    }
    
    /******************************************************************************************
    *
    ******************************************************************************************/
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        
    }
    
    /******************************************************************************************
    *
    ******************************************************************************************/
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return events[section].count
    }
    
    /******************************************************************************************
    *
    ******************************************************************************************/
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        if section == 0
        {
            return "Upcoming events"
        }
        else
        {
            return "Past events"
        }
    }
    
    /******************************************************************************************
    *
    ******************************************************************************************/
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 2
    }
    
}