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

class ViewEventController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate, UIGestureRecognizerDelegate
{
    let locationManager  = CLLocationManager()
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet var viewPanHandle: UIPanGestureRecognizer!
    @IBOutlet weak var navBarTitle: UINavigationItem!
    
    @IBOutlet weak var slideView: UIView!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var hostedByLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    var locationText = ""
    var hostedByPic:UIImage?
    var hostedByText = ""
    
    var slideViewFrame:CGRect?
    var event:Event?
    
    /******************************************************************************************
    *   Configure map view and center at the event location
    *   Set navbar title to the event title
    *   Configure the details of the scrollview
    ******************************************************************************************/
    override func viewDidLoad()
    {
        super.viewDidLoad()
        navBarTitle?.title = locationText
//        view.bringSubviewToFront(navBar)

        // Configure map view
        mapView.delegate = self
        locationManager.delegate = self
        mapView.settings.compassButton = true
        
        // REMOVE THIS ONCE WE STORE THE EVENT LOCATION
//        event!.EventCoordinates = CLLocationCoordinate2D(latitude: 41.659727, longitude: -91.536210)
        
        
        mapView.camera = GMSCameraPosition(target: event!.EventCoordinates!, zoom: 15, bearing: 0, viewingAngle: 0)

        // set event details
        profilePic.image = hostedByPic
        hostedByLabel.text = "\(hostedByLabel.text!) \(hostedByText)"
//        locationLabel.text = "\(locationLabel.text!) \(locationText)"
        timeLabel.text = "\(timeLabel.text!) Tonight at 8pm"
    }
    
    /******************************************************************************************
    *   Set the position and size of the scrollview
    ******************************************************************************************/
    override func viewWillAppear(animated: Bool)
    {
        slideView.frame = CGRectMake(0, UIScreen.mainScreen().bounds.height - 50, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height)
    }
    
    /******************************************************************************************
    *
    ******************************************************************************************/
    @IBAction func handleTap(sender: UITapGestureRecognizer)
    {
//                slideViewPosition = sender.view?.layer.positio
//        slideViewFrame = slideView.frame
//        println("tap frame \(slideViewFrame)")
//        sender.view!.layer.removeAllAnimations()
//
//        println("TAP")
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
            
//            println("ENDED")
        }

    }
    
    /******************************************************************************************
    *   Return to previous view
    ******************************************************************************************/
    @IBAction func backButtonPressed(sender: AnyObject)
    {
        dismissViewControllerAnimated(true, completion: { () -> Void in })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "toChat"
        {
            let controller = segue.destinationViewController as MessagesViewController
            controller.chatRoomName = event!.EventID!
        }
    }
    
}