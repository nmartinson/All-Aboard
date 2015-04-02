//
//  ViewController.swift
//  All Aboard
//
//  Created by Nick Martinson on 1/28/15.
//  Copyright (c) 2015 Nick Martinson. All rights reserved.
//

import UIKit
import Alamofire
import MobileCoreServices

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    let AWS = AWShelper()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profilePic: UIImageView!
    var events:[[Event]] = [[],[]]
    var selectedEvent:[String:AnyObject] = ["row":0, "section":0, "indexPath": NSIndexPath()]
    let imagePicker = UIImagePickerController()
    
    /******************************************************************************************
    *
    ******************************************************************************************/
    override func viewDidLoad()
    {
        let GUID = UserPreferences().getGUID()
        
        // dowload profile pic
        AWShelper().downloadThumbnailImageFromS3("profilePictures", file: GUID, photoNumber: nil)
        {
            (image:UIImage?) in
            if image != nil
            {
                self.profilePic.image = image
            }
        }
        
        BluemixCommunication().getUserInviteList(UserPreferences().getGUID())
        {
            (events: [Event]) in
            let currentTime = NSDate()
            for item in events
            {
                
                if item.EventStartDate?.earlierDate(currentTime) == currentTime
                {
                    self.events[0].append(item)
                }
                else
                {
                    self.events[1].append(item)
                }
            }
//            self.events[0] = events
            self.tableView.reloadData()
        }
        
        imagePicker.delegate = self
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
    
    /******************************************************************************************
    *
    ******************************************************************************************/
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(true)
        tableView.deselectRowAtIndexPath(selectedEvent["indexPath"] as NSIndexPath, animated: true)
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
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "profileToEvent"
        {
            let navController = segue.destinationViewController as UINavigationController
            let controller = navController.viewControllers.first as ViewEventController
            controller.event = events[selectedEvent["section"]! as Int][selectedEvent["row"]! as Int]
        }
    }
    /******************************************************************************************
    *
    ******************************************************************************************/
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let  cell = tableView.dequeueReusableCellWithIdentifier("eventCell") as UITableViewCell
        cell.textLabel?.text = events[indexPath.section][indexPath.row].EventName
        return cell
    }
    
    /******************************************************************************************
    *
    ******************************************************************************************/
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        selectedEvent = ["row": indexPath.row, "section": indexPath.section, "indexPath": indexPath]
        performSegueWithIdentifier("profileToEvent", sender: self)
//        tableView.cellForRowAtIndexPath(indexPath)?.selected = false
//        tableView.cellForRowAtIndexPath(indexPath)?.highlighted = false
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
    
    /******************************************************************************************
    *   Configure the swipe right for the hidden menu
    ******************************************************************************************/
    @IBAction func menuButtonPressed(sender: AnyObject)
    {
        revealViewController().revealToggle(sender)
    }
    
    @IBAction func profileSettingsPressed(sender: AnyObject)
    {
        var alertView = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        var changePicture = UIAlertAction(title: "Change Picture", style: .Default)
            {
                action in
                self.openGallery()
        }

        var cameraAction = UIAlertAction(title: "Camera", style: .Default)
            {
                action in
                self.openCamera()
        }

        var cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        alertView.addAction(changePicture)
        alertView.addAction(cameraAction)
        alertView.addAction(cancelAction)
        
        presentViewController(alertView, animated: true, completion: nil)
    }
    
    /******************************************************************************************
    *   Open camera roll
    ******************************************************************************************/
    func openGallery()
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum)
        {
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            imagePicker.mediaTypes = [kUTTypeImage as NSString]
            imagePicker.allowsEditing = false
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    /******************************************************************************************
    *   Open camera
    ******************************************************************************************/
    func openCamera()
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        {
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            imagePicker.mediaTypes = [kUTTypeImage as NSString]
            imagePicker.allowsEditing = false
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    /******************************************************************************************
    *   Save the picked image
    ******************************************************************************************/
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!)
    {
        profilePic.image = image
        let file = UserPreferences().getGUID()
        self.dismissViewControllerAnimated(true)
        {
            self.AWS.uploadThumbnailToS3(self.AWS.compressImageToThumbnail(image), folder: "profilePictures", file: file, photoNumber: nil)
            self.AWS.uploadToS3(self.AWS.compressImage(image), folder: "profilePictures", file: file, photoNumber: nil, alertView: nil) // upload image
        }
    }
    
}