//
//  CreateEventViewController.swift
//  All Aboard
//
//  Created by Ian Brauer on 1/28/15.
//  Copyright (c) 2015 Ian Brauer. All rights reserved.
//

import UIKit
import Alamofire


class CreateEventViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate
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
    var places:[GooglePlace] = []
    var googleSearch = GoogleSearch()
    var searchString = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell = tableView.dequeueReusableCellWithIdentifier("searchCell") as UITableViewCell
        
        cell.textLabel?.text = places[indexPath.row].name
        return cell
    }
    
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

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
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
            println("Text:\(searchString)")

            
            if range.location == 0
            {
                searchTableView.hidden = true
            }
            else
            {
                googleSearch.fetchPlaces(searchString){
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
    @IBAction func onAddFriendsPress(sender: AnyObject) {
        
        println(eventType)

//        var event = Event(name: eventNameTextField.text ,location: eventlocationTextField.text, date: eventDate.date)
//        tf.text = event.EventName
//        loc.text = event.EventLocation

        let hostId = UserPreferences().getGUID()
        
        let date = eventDate.date
        let timestamp = (date.timeIntervalSince1970) * 1000
        let timestampInMs = Int(timestamp)
        
        Alamofire.request(.POST,"http://hangout.mybluemix.net/NewEvent", parameters: ["action": "120", "title":eventNameTextField.text, "host":hostId,"lat":41.667,"lon":91.533,"startTime":timestampInMs,"endTime":timestampInMs] ).responseString { (_, response, string,_) -> Void in
            println("response:\(string)")
        }
    }
 
}