//
//  CreateEventViewController.swift
//  All Aboard
//
//  Created by Ian Brauer on 1/28/15.
//  Copyright (c) 2015 Ian Brauer. All rights reserved.
//

import UIKit
import Alamofire
import MobileCoreServices


class CreateEventViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate, CustomDatePickerDelegate
{
    
    //the variable holding whether the event is a poll or regular event
    var eventType=0
    //the label for the location
    @IBOutlet weak var loc: UILabel!
    //the label for the name
    @IBOutlet weak var tf: UILabel!
    //the text field the user puts the name into
    @IBOutlet weak var eventNameTextField: UITextField!
    //the text field the user puts the location into
    @IBOutlet weak var eventlocationTextField: UITextField!
    //the date picker object
    @IBOutlet weak var eventDate: UIDatePicker!

    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var startTime: UIButton!
    @IBOutlet weak var endTime: UIButton!
    @IBOutlet weak var errorField: UILabel!
    
    var startDate:NSDate?
    var endDate:NSDate?
    var currentEvent:Event?
    var selectedButton:UIButton?  // used for storing whether the start or end time button was selected
    var places:[GooglePlace] = []
    var googleSearch = GoogleSearch()
    var searchString = ""
    var selectedIndex = 0   // index of selected segment
    var finishedGettingPlaceDetail = false  // used to block from creating event until place info has been received
    let dateView = DatePickerController()   // date picker that is presented in it's own view
    let dateViewFrame = DatePickerController().frame    // initial size of the date picker
    let locationManager = CLLocationManager()
    var location:CLLocationCoordinate2D?

    
    
    /******************************************************************************************
    *
    ******************************************************************************************/
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        searchTableView.layer.cornerRadius = 5
        locationManager.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse
        {
            locationManager.startUpdatingLocation()
            location = locationManager.location.coordinate
        }
    }

    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(true)
        clearView()
        locationManager.stopUpdatingLocation()
    }

    
    /******************************************************************************************
    *
    ******************************************************************************************/
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell = tableView.dequeueReusableCellWithIdentifier("searchCell") as UITableViewCell
        
        cell.textLabel?.text = places[indexPath.row].name
        return cell
    }
    
    /******************************************************************************************
    *
    ******************************************************************************************/
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if places.count == 0
        {
            tableView.hidden = true
        }
        else
        {
            tableView.hidden = false
        }
        return places.count
    }

    /******************************************************************************************
    *
    ******************************************************************************************/
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        eventlocationTextField.text = places[indexPath.row].shortName
        selectedIndex = indexPath.row
        
        let placeID = places[indexPath.row].place_id!
        GoogleSearch().fetchPlaceDetails(placeID)
        {
            (place: GooglePlaceDetail) in
            self.places[indexPath.row].coordinate = place.coordinates
            println(place.coordinates?.longitude)
            self.finishedGettingPlaceDetail = true
        }
        eventlocationTextField.resignFirstResponder()
        tableView.hidden = true
    }
    
    /******************************************************************************************
    *
    ******************************************************************************************/
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        if textField == eventNameTextField
        {
            eventlocationTextField.becomeFirstResponder()
        }
        else if textField == eventlocationTextField
        {
            textField.resignFirstResponder()
            startTime.sendActionsForControlEvents(.TouchUpInside)
        }

        return true
    }
    
    /******************************************************************************************
    *   Reset the entire view back to inital with no values
    ******************************************************************************************/
    func clearView()
    {
        searchString = ""
        eventNameTextField.text = ""
        eventlocationTextField.text = ""
        places = []
        searchTableView.hidden = true
        searchTableView.reloadData()
        errorField.text = ""
        startTime.setTitle("Start time: ", forState: .Normal)
        endTime.setTitle("End time: ", forState: .Normal)
        startDate = nil
        endDate = nil
    }
    
    /******************************************************************************************
    *   Configure the swipe right for the hidden menu
    ******************************************************************************************/
    @IBAction func revealButtonPressed(sender: AnyObject)
    {
        revealViewController().revealToggle(sender)
    }
    
    /******************************************************************************************
    *   Present the date picker with an animation. Hide the tab bar
    ******************************************************************************************/
    @IBAction func selectTimePressed(sender: UIButton)
    {
        dateView.delegate = self
        dateView.frame = CGRectMake(0, UIScreen.mainScreen().bounds.height + dateView.bounds.height, dateViewFrame.width, dateViewFrame.height)
        
        if sender == startTime
        {
            dateView.setDescription("Start Time")
        }
        else
        {
            dateView.setDescription("End Time")
        }
        view.addSubview(dateView)
        
        UIView.transitionWithView(self.view,
            duration: 0.5,
            options: UIViewAnimationOptions.AllowAnimatedContent,
            animations: {
                self.dateView.frame = self.dateViewFrame
                self.tabBarController?.tabBar.hidden = true
            },
            completion: nil)
        view.bringSubviewToFront(dateView)
        selectedButton = sender
    }
    
    /******************************************************************************************
    *
    ******************************************************************************************/
    func doneButtonPressed()
    {
        UIView.transitionWithView(self.view,
            duration: 0.5,
            options: UIViewAnimationOptions.AllowAnimatedContent,
            animations: {
                self.dateView.frame = CGRectMake(0, UIScreen.mainScreen().bounds.height + self.dateView.bounds.height, self.dateView.frame.width, self.dateView.frame.height)
                self.tabBarController?.tabBar.hidden = false
            }){ Void in self.dateView.removeFromSuperview()
        }

        self.tabBarController?.tabBar.hidden = false
        if selectedButton == startTime
        {
            startDate = dateView.datePicker.date
            let formatter = NSDateFormatter()
            formatter.dateFormat = "MMMM d, yyyy h:mm a"
            let date = formatter.stringFromDate(dateView.datePicker.date)
            let title = "Start time:\t" + date
            selectedButton!.setTitle(title, forState: .Normal)
        }
        else
        {
            endDate = dateView.datePicker.date
            let formatter = NSDateFormatter()
            formatter.dateFormat = "MMMM d, yyyy h:mm a"
            let date = formatter.stringFromDate(dateView.datePicker.date)
            let title = "End time:    " + date
            selectedButton!.setTitle(title, forState: .Normal)
        }
    }
    
    /******************************************************************************************
    *
    ******************************************************************************************/
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "inviteFriends"
        {
            let controller = segue.destinationViewController as InviteFriendsToEventController
            controller.currentEvent = currentEvent!
        }
    }
    
    /***********************************************FUNCTIONS********************************************************/
    
    
    /**
    *   This is a function called after the user changes the event type. The segmentcontroller is the sender and it will
    *   run this function everytime it is changed and sets a variable
    */
    @IBAction func eventTypeOption(sender: UISegmentedControl) {
        eventType = sender.selectedSegmentIndex
    }
    
    
    /**
    *   This function is called every time the user enters a character into the location textfield. It calls the autocomplete 
    *   feature of the Google Places API and completes it from nearby places. This is used for quick filling of businesses and
    *   for a generally faster response
    *  
    *   textField is the tf itsself, range is the range of how many characters it counts, string is the current character being 
    *   added or deleted
    
    *   HTTP request to the Google Places servers to get nearby places. (using Alamofire)
    *   params: key:google API key
    *           input: the letters google should search with
    *           location: the devices location so the user gets places around them
    */
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool
    {
        if textField.isEqual(eventlocationTextField)
        {
            let searchString = textField.text.stringByReplacingOccurrencesOfString(" ", withString: "_")
//            println("Text:\(searchString)")

            
            if range.location == 0
            {
                searchTableView.hidden = true
            }
            else
            {
                
                googleSearch.fetchPlaces(searchString, coordinates: location!){
                    (newPlaces: [GooglePlace]) in
                    self.places = newPlaces
                    self.searchTableView.reloadData()
                }
            }
        }
        return true
    }
    
    /**
    *   This is the listener on the add friends button for the app. As soon as the user is done making the event they can click
    *   Add friends and it will actually make the event and store it in the database. 
    *   
    *   HTTP Request to the back end and data storage on IBM Bluemix. 
    *   params: title: the name of the event being stored
    *           host: the user that creates the event
    *           lat: the lattitude of the location the event is to be held
    *           lon: the longitude of the location the event is to be held
    *           startTime: the time the event is going to start/ when people should meet
    *           endTime: the time the event will end
    */
    @IBAction func onAddFriendsPress(sender: AnyObject)
    {
        if !(eventlocationTextField.text == "" || eventNameTextField.text == "" || startDate == nil || endDate == nil)
        {
            let hostId = UserPreferences().getGUID()
            while( finishedGettingPlaceDetail == false){}
            let coordinates = places[selectedIndex].coordinate
            currentEvent = Event(name: eventNameTextField.text, location: eventlocationTextField.text, coordinates: coordinates!, hostID: hostId, eventStartDate: startDate!, eventEndDate: endDate!)

            performSegueWithIdentifier("inviteFriends", sender: self)
        }
        else
        {
            //must select location, name, and times
            errorField.text = "Must set event name, location, and times."
        }
    }
 
}