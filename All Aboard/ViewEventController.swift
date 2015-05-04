//
//  ViewEventController.swift
//  All Aboard
//
//  Created by Nick Martinson on 2/8/15.
//  Copyright (c) 2015 Nick Martinson. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import MobileCoreServices

class ViewEventController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate, UIGestureRecognizerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate
{
    let AWS = AWShelper()
    let locationManager  = CLLocationManager()
    let imagePicker = UIImagePickerController()
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var navBarTitle: UINavigationItem!
    
    @IBOutlet weak var mainScrollView: OverlayScrollView!
    @IBOutlet weak var slideView: UIView!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var hostedByLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var eventPhotosLabel: UILabel!
    @IBOutlet weak var uploadPhotoButton: UIButton!
    @IBOutlet weak var acceptDenyView: UIView!
    var locationText = ""
    var hostedByPic:UIImage?
    var hostedByText = ""

    
    @IBOutlet weak var attendeeCollectionView: UICollectionView!
    @IBOutlet weak var photoGalleryCollectionView: UICollectionView!
    var cachedThumbnails = [String:UIImage]()
    var cachedLargeImages = [String:UIImage]()
    var cachedAttendee = [String:UIImage]()
    var attendeeList:[User] = []
    var photoCollection:[UIImage] = []
    var statusBarHidden = false
    var slideViewFrame:CGRect?
    var event:Event?
    var imageView:UIImageView?
    var imageScroll:UIScrollView = UIScrollView()
    var blackView = UIView()
    var acceptedInvite = true
    var customNavigationBar = UINavigationBar()
    
        
    /******************************************************************************************
    *   Configure map view and center at the event location
    *   Set navbar title to the event title
    *   Configure the details of the scrollview
    ******************************************************************************************/
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        println("\n\(event!.EventID!)\n")
        
        navBarTitle?.title = locationText
        imagePicker.delegate = self
        mainScrollView.contentSize = CGSizeMake(375, 1100)
        mainScrollView.setContentOffset(CGPointMake(0, 300), animated: true)
        
        imageScroll.showsHorizontalScrollIndicator = false
        imageScroll.showsVerticalScrollIndicator = false
        imageScroll.delegate = self
        
        blackView.frame = self.view.frame
        blackView.backgroundColor = UIColor.blackColor()
        blackView.alpha = 0
        
        var doubleTapGesture = UITapGestureRecognizer(target: self, action: "closeImage:")
        doubleTapGesture.numberOfTapsRequired = 2
        imageScroll.addGestureRecognizer(doubleTapGesture)
        
        // Configure map view
        mapView.delegate = self
        locationManager.delegate = self
        mapView.settings.compassButton = true
        
        // ask for current location
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse
        {
            locationManager.startUpdatingLocation()
            mapView.myLocationEnabled = true
            mapView.settings.myLocationButton = true
        }

        mapView.camera = GMSCameraPosition(target: event!.EventCoordinates!, zoom: 15, bearing: 0, viewingAngle: 0)
        var marker = GMSMarker(position: event!.EventCoordinates!)
        marker.map = mapView
        
        // set event details
        profilePic.image = hostedByPic
        profilePic.layer.borderColor = UIColor.blackColor().CGColor
        profilePic.layer.borderWidth = 2
        timeLabel.text = "Start: \(Helper().formatDateString(event!.EventStartDate!))"
        endTimeLabel.text = "End: \(Helper().formatDateString(event!.EventEndDate!))"
        timeLabel.font = UIFont(name: timeLabel.font.fontName, size: 12)
        endTimeLabel.font = UIFont(name: endTimeLabel.font.fontName, size: 12)
        locationLabel.text = "Location: \(event!.EventLocation!)"
        hostedByLabel.text = "Host: \(event!.EventHostName!)"
        marker.title = event!.EventName! as String
        
        if acceptedInvite
        {
            eventPhotosLabel.hidden = false
            uploadPhotoButton.hidden = false
            acceptDenyView.hidden = true
            // Check the number of images that are in the event folder
            AWS.numberOfFilesInFolder(event!.EventID! as String)
            {
                (count: Int) in
                self.event!.EventPhotoNumber = count
                self.photoGalleryCollectionView.reloadData()
            }
        }
        else
        {
            acceptDenyView.hidden = false
            eventPhotosLabel.hidden = true
            uploadPhotoButton.hidden = true
        }

        // download the profile picture
        AWS.downloadThumbnailImageFromS3("profilePictures", file: event!.EventHostID! as String, photoNumber: nil)
        {
            (image:UIImage?) in
            self.profilePic.image = image
        }
        
        BluemixCommunication().getEventAttendees(event!.EventID! as String)
        {
            (attendees: [User]) in
            println(attendees)
            self.attendeeList = attendees
            self.attendeeCollectionView.reloadData()
            
        }
        
    }
    
    /******************************************************************************************
    *   Set the position and size of the scrollview
    ******************************************************************************************/
    override func viewWillAppear(animated: Bool)
    {
//        slideView.frame = CGRectMake(0, UIScreen.mainScreen().bounds.height - 50, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height)
    }
    
    
    /******************************************************************************************
    *   Open the camera roll
    ******************************************************************************************/
    @IBAction func cameraRollPressed(sender: AnyObject)
    {
        var alertView = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        var cameraAction = UIAlertAction(title: "Camera", style: .Default)
        {
            action in
            self.openCamera()
        }
        var galleryAction = UIAlertAction(title: "Gallery", style: .Default)
        {
            action in
            self.openGallery()
        }
        var cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        alertView.addAction(cameraAction)
        alertView.addAction(galleryAction)
        alertView.addAction(cancelAction)
        
        presentViewController(alertView, animated: true, completion: nil)
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
    *   Save the picked image
    ******************************************************************************************/
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!)
    {
        let folder = event!.EventID!    // use the event id as the folder name since it is unique
        var alert = UIAlertController(title: "Uploading", message: "%", preferredStyle: .Alert)
        self.presentViewController(alert, animated: true, completion: nil)
        
        // upload thumbnail and real size
        AWS.uploadThumbnailToS3(AWS.compressImageToThumbnail(image), folder: folder as String, file: nil, photoNumber: cachedThumbnails.count)
        AWS.uploadToS3(AWS.compressImage(image), folder: folder as String, file: nil, photoNumber: cachedThumbnails.count, alertView: alert) // upload image

        let key = "Cell\(cachedThumbnails.count)"
        cachedThumbnails[key] = image
        
        event!.EventPhotoNumber++
        self.dismissViewControllerAnimated(true)
        {
            Void in
            
        }
        photoGalleryCollectionView.reloadData()
    }
    
    /******************************************************************************************
    *   When a cell is about to be displayed, the image gets set
    ******************************************************************************************/
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        if collectionView == photoGalleryCollectionView
        {
            var cell = collectionView.dequeueReusableCellWithReuseIdentifier("photoCell", forIndexPath: indexPath) as! PhotoGalleryCollectionViewCell
            let key = "Cell\(indexPath.item)"
            if cachedThumbnails[key] != nil
            {
                cell.image.image = cachedThumbnails[key]
            }
            else
            {
                self.AWS.downloadThumbnailImageFromS3(self.event!.EventID! as String, file: nil, photoNumber: indexPath.item)
                {
                    (image: UIImage?) in
                    if image != nil
                    {
                        self.cachedThumbnails[key] = image!
                            (collectionView.cellForItemAtIndexPath(indexPath) as! PhotoGalleryCollectionViewCell).image.image = image
                    }
                }
            }
            return cell
        }
        else
        {
            var cell = collectionView.dequeueReusableCellWithReuseIdentifier("attendeeCell", forIndexPath: indexPath) as! EventAttendeeCell
            cell.attendeeName.text = attendeeList[indexPath.item].realname! as String
            let file = attendeeList[indexPath.item].userid
            AWS.downloadThumbnailImageFromS3("profilePictures", file: file as String, photoNumber: nil)
            {
                (image: UIImage?) in
                cell.profilePicture.image = image
            }
            return cell
        }
    }
    
    /******************************************************************************************
    *   Open the image to full screen with animation when selected
    ******************************************************************************************/
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        if collectionView == photoGalleryCollectionView
        {
            let thumbnail = collectionView.cellForItemAtIndexPath(indexPath)?.contentView.subviews.last as! UIImageView
            let key = "Cell\(indexPath.item)"
            if cachedLargeImages[key] != nil
            {
                self.imageScroll.frame = self.view.frame
                self.cachedLargeImages[key] = cachedLargeImages[key]
                self.imageView = UIImageView(image: self.cachedLargeImages[key])
                let imageSize = self.imageView!.frame.size
                self.imageScroll.maximumZoomScale = 6.0
                self.imageScroll.contentSize = imageSize
                let widthScale = self.imageScroll.bounds.size.width / imageSize.width
                let heightScale = self.imageScroll.bounds.size.height / imageSize.height
                self.imageScroll.minimumZoomScale = min(widthScale, heightScale)
                self.imageScroll.setZoomScale(max(widthScale, heightScale), animated: true )
                
                self.imageScroll.addSubview(self.imageView!)
                self.view.addSubview(self.blackView)
                
                // hide the status bar
                self.statusBarHidden = true
                self.prefersStatusBarHidden()
                
                // open the image
                UIView.transitionWithView(self.view, duration: 1,
                    options: UIViewAnimationOptions.AllowAnimatedContent,
                    animations: {
                        self.navigationController?.navigationBar.alpha = 0 // hide navbar
                        self.blackView.alpha = 1    // show black background
                        self.view.addSubview(self.imageScroll)
                        self.imageScroll.contentSize = self.imageView!.frame.size},
                    completion: nil)
            }
            else
            {
                self.imageScroll.frame = self.view.frame

                self.view.addSubview(self.blackView)
                UIView.transitionWithView(self.view, duration: 1,
                    options: UIViewAnimationOptions.AllowAnimatedContent,
                    animations: {
                        self.navigationController?.navigationBar.alpha = 0 // hide navbar
                        self.blackView.alpha = 1},    // show black background
                    completion: nil)

                AWS.downloadImageFromS3(event!.EventID! as String, file: nil, photoNumber: indexPath.item)
                {
                    (image: UIImage?) in
                    self.cachedLargeImages[key] = image
                    self.imageView = UIImageView(image: self.cachedLargeImages[key])
                    let imageSize = self.imageView!.frame.size
                    self.imageScroll.maximumZoomScale = 6.0
                    self.imageScroll.contentSize = imageSize
                    var widthScale = self.imageScroll.bounds.size.width / imageSize.width
                    var heightScale = self.imageScroll.bounds.size.height / imageSize.height
                    self.imageScroll.minimumZoomScale = min(widthScale, heightScale)
                    self.imageScroll.setZoomScale(max(widthScale, heightScale), animated: true )
                    
                    self.imageScroll.addSubview(self.imageView!)
                    
                    // hide the status bar
                    self.statusBarHidden = true
                    self.prefersStatusBarHidden()
                    
                    // open the image
                    UIView.transitionWithView(self.view, duration: 1,
                        options: UIViewAnimationOptions.AllowAnimatedContent,
                        animations: {
                            self.navigationController?.navigationBar.alpha = 0 // hide navbar
                            self.blackView.alpha = 1    // show black background
                            self.view.addSubview(self.imageScroll)
                            self.imageScroll.contentSize = self.imageView!.frame.size},
                        completion: nil)
                }
            }
        }
    }
    
    
    /******************************************************************************************
    *   Closes the open image with a fading transition
    ******************************************************************************************/
    func closeImage(recognizer: UITapGestureRecognizer)
    {
        // show the status bar
        statusBarHidden = false
        self.prefersStatusBarHidden()

        UIView.transitionWithView(self.view, duration: 0.5,
            options: UIViewAnimationOptions.AllowAnimatedContent,
            animations: {
                self.navigationController?.navigationBar.alpha = 1
                self.imageView?.alpha = 0
                self.blackView.alpha = 0
            },
            completion: { Void in
                self.blackView.removeFromSuperview()
                self.imageScroll.removeFromSuperview()
                self.imageView?.removeFromSuperview()
        })
    }
    
    /******************************************************************************************
    *   Specifies that the status bar animation style should be fade
    ******************************************************************************************/
    override func preferredStatusBarUpdateAnimation() -> UIStatusBarAnimation
    {
        return UIStatusBarAnimation.Fade
    }
    
    /******************************************************************************************
    *   Hides and shows the status bar
    ******************************************************************************************/
    override func prefersStatusBarHidden() -> Bool
    {
        return statusBarHidden
    }
    
    /******************************************************************************************
    *   Return the imageview that should be zoomed
    ******************************************************************************************/
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView?
    {
        return imageView
    }
    
    /******************************************************************************************
    *   When the scrollview ends zooming the content size needs to be updated to the new size 
    *   of the imageview, then the imageview needs to be centered.
    ******************************************************************************************/
    func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView!, atScale scale: CGFloat)
    {
        scrollView.contentSize = CGSizeMake(imageView!.image!.size.width*scale, imageView!.image!.size.height*scale)
        centerScrollViewContents()
    }

    /******************************************************************************************
    *   Centers the image when zooming
    ******************************************************************************************/
    func centerScrollViewContents()
    {
        let boundsSize = imageScroll.bounds.size
        var contentsFrame = imageView!.frame
        
        if contentsFrame.size.width < boundsSize.width
        {
            contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0
        }
        else
        {
            contentsFrame.origin.x = 0.0
        }
        if contentsFrame.size.height < boundsSize.height
        {
            contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0
        }
        else
        {
            contentsFrame.origin.y = 0.0
        }
        
        UIView.transitionWithView(self.view, duration: 0.1,
            options: UIViewAnimationOptions.AllowAnimatedContent,
            animations: { self.imageView!.frame = contentsFrame},
            completion: nil)
    }
    
    /******************************************************************************************
    *   Tells the collection view how many images to display
    ******************************************************************************************/
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if collectionView == photoGalleryCollectionView
        {
            return event!.EventPhotoNumber
        }
        else
        {
            return attendeeList.count
        }
    }
    
    /******************************************************************************************
    *   Return to previous view
    ******************************************************************************************/
    @IBAction func backButtonPressed(sender: AnyObject)
    {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    /******************************************************************************************
    *
    ******************************************************************************************/
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "toChat"
        {
            let controller = segue.destinationViewController as! MessagesViewController
            controller.chatRoomName = event!.EventID! as String
        }
    }
    
    func chatPressed()
    {
        performSegueWithIdentifier("toChat", sender: self)
    }
    
    /****************************************************************************************************
    *   These two methods are connected to the event accept/deny buttons
    *****************************************************************************************************/
    @IBAction func denyInviteButtonPressed(sender: UIButton)
    {
        let userID = UserPreferences().getGUID()
        BluemixCommunication().denyEventInvite(event!.EventID! as String, userID: userID)
        {
                (result: String) in
                if result == RETURNCODES.INVITE_DECLINE_SUCCES
                {
                    self.acceptedInvite = false
                    self.eventPhotosLabel.hidden = true
                    self.uploadPhotoButton.hidden = true
                    self.acceptDenyView.hidden = false
                }
        }

    }
    
    @IBAction func acceptInviteButtonPressed(sender: UIButton)
    {
        let userID = UserPreferences().getGUID()
        BluemixCommunication().acceptEventInvite(event!.EventID! as String, userID: userID)
        {
            (result: String) in
            if result == RETURNCODES.INVITE_ACCEPT_SUCCESS
            {
                // Check the number of images that are in the event folder
                self.AWS.numberOfFilesInFolder(self.event!.EventID! as String)
                {
                    (count: Int) in
                    self.event!.EventPhotoNumber = count
                    self.photoGalleryCollectionView.reloadData()
                }
                
                let chatButton = UIBarButtonItem(title: "Chat", style: .Plain, target: self, action: "chatPressed")
                self.navigationItem.rightBarButtonItem = chatButton
                self.acceptedInvite = true
                self.eventPhotosLabel.hidden = false
                self.uploadPhotoButton.hidden = false
                self.acceptDenyView.hidden = true
            }
        }
    }
    
    
    
    func showLoading()
    {

        
    }

    
    
}