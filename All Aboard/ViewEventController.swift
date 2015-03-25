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
    let locationManager  = CLLocationManager()
    let imagePicker = UIImagePickerController()
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet var viewPanHandle: UIPanGestureRecognizer!
    @IBOutlet weak var navBarTitle: UINavigationItem!
    
    @IBOutlet weak var mainScrollView: OverlayScrollView!
    @IBOutlet weak var slideView: UIView!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var hostedByLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    var locationText = ""
    var hostedByPic:UIImage?
    var hostedByText = ""
    
    @IBOutlet weak var photoGalleryCollectionView: UICollectionView!
    var photoCollection:[UIImage] = []
    var statusBarHidden = false
    var slideViewFrame:CGRect?
    var event:Event?
    var imageView:UIImageView?
    var imageScroll:UIScrollView = UIScrollView()
    var blackView = UIView()
    
        
    /******************************************************************************************
    *   Configure map view and center at the event location
    *   Set navbar title to the event title
    *   Configure the details of the scrollview
    ******************************************************************************************/
    override func viewDidLoad()
    {
        super.viewDidLoad()
        navBarTitle?.title = locationText
        imagePicker.delegate = self
        mapView.bringSubviewToFront(mainScrollView)

        mainScrollView.contentSize = CGSizeMake(UIScreen.mainScreen().bounds.width, 2000)
//        slideView.frame = CGRectMake(0, 500, mainScrollView.bounds.width, slideView.bounds.height)
        // Test image
        photoCollection.append(UIImage(named: "testImage")!)
        
        imageScroll.delegate = self
        imageScroll.frame = UIScreen.mainScreen().bounds
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
        timeLabel.text = Helper().formatDateString(event!.EventStartDate!)
        locationLabel.text = event!.EventLocation!
        hostedByLabel.text = "Host: \(event!.EventHostName!)"
        marker.title = event!.EventName!
    
//        BluemixCommunication().getImage()
//        {
//            (image: UIImage?) in
//            if image != nil
//            {
//                self.photoCollection.append(image!)
//                self.photoGalleryCollectionView.reloadData()
//            }
//        }
    }
    
    /******************************************************************************************
    *   Set the position and size of the scrollview
    ******************************************************************************************/
    override func viewWillAppear(animated: Bool)
    {
//        slideView.frame = CGRectMake(0, UIScreen.mainScreen().bounds.height - 50, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height)
    }
    
    /******************************************************************************************
    *   Used to allow scrolling of the view
    ******************************************************************************************/
    @IBAction func handlePan(recognizer:UIPanGestureRecognizer)
    {

        let translation = recognizer.translationInView(self.view)
        recognizer.view!.center = CGPoint(x:recognizer.view!.center.x, y:recognizer.view!.center.y + translation.y)

        recognizer.setTranslation(CGPointZero, inView: self.view)
        if recognizer.state == UIGestureRecognizerState.Changed
        {
//            println("CANCELED")
//            slideViewFrame = slideView.frame
//            recognizer.view?.layer.removeAllAnimations()
//            if self.slideViewFrame != nil
//            {
//                recognizer.view!.frame = self.slideViewFrame!
//            }
//            println("COMPLETE")
        }
        if recognizer.state == UIGestureRecognizerState.Ended
        {
            let velocity = recognizer.velocityInView(self.view)
            let magnitude = sqrt((velocity.y * velocity.y))
            let slideMultiplier = magnitude / 200
            
            let slideFactor = 0.1 * slideMultiplier     //Increase for more of a slide
            
            var finalPoint = CGPoint(x:recognizer.view!.center.x, y:recognizer.view!.center.y + (velocity.y * slideFactor))
            
            finalPoint.y = min(max(finalPoint.y, 0), recognizer.view!.bounds.height + 100)
            
            UIView.animateWithDuration(Double(slideFactor*2), delay: 0,
                options: UIViewAnimationOptions.AllowUserInteraction | UIViewAnimationOptions.CurveLinear | UIViewAnimationOptions.BeginFromCurrentState,
                animations: {recognizer.view!.center = finalPoint },
                completion: nil)
            
        }

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
        photoCollection.append(image)
        AWShelper().uploadToS3(image)
//        BluemixCommunication().sendImage(image)
        self.dismissViewControllerAnimated(true, completion: nil)
        photoGalleryCollectionView.reloadData()
    }
    
    /******************************************************************************************
    *   When a cell is about to be displayed, the image gets set
    ******************************************************************************************/
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("photoCell", forIndexPath: indexPath) as PhotoGalleryCollectionViewCell
        cell.image.image = photoCollection[indexPath.item]

        return cell
    }
    
    /******************************************************************************************
    *   Open the image to full screen with animation when selected
    ******************************************************************************************/
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        let thumbnail = collectionView.cellForItemAtIndexPath(indexPath)?.contentView.subviews.last as UIImageView
        imageView = UIImageView(image: photoCollection[indexPath.row])
        imageView!.contentMode = thumbnail.contentMode
        imageScroll.contentSize = imageView!.frame.size
        
        let scaleWidth = imageScroll.frame.size.width / imageScroll.contentSize.width
        let scaleHeight = imageScroll.frame.size.height / imageScroll.contentSize.height
        let minScale = min(scaleHeight, scaleWidth)
        imageScroll.minimumZoomScale = minScale
        imageScroll.maximumZoomScale = 1
        imageScroll.zoomScale = minScale
        imageScroll.frame = thumbnail.frame
        imageScroll.addSubview(imageView!)
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
                self.imageScroll.frame = self.view.frame
                self.imageView!.center = self.imageScroll.center
                self.imageScroll.contentSize = self.imageView!.frame.size},
            completion: nil)
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

    func scrollViewDidScroll(scrollView: UIScrollView)
    {
        if scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.frame.size.height
        {
            scrollView.setContentOffset(CGPointMake(scrollView.contentOffset.x, scrollView.contentSize.height - scrollView.frame.size.height), animated: false)
        }
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
        
        UIView.transitionWithView(self.view, duration: 0.5,
            options: UIViewAnimationOptions.AllowAnimatedContent,
            animations: { self.imageView!.frame = contentsFrame},
            completion: nil)
    }
    
    /******************************************************************************************
    *   Tells the collection view how many images to display
    ******************************************************************************************/
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return photoCollection.count
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
            let controller = segue.destinationViewController as MessagesViewController
            controller.chatRoomName = event!.EventID!
        }
    }
    
}