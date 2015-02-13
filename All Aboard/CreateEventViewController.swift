//
//  ViewController.swift
//  All Aboard
//
//  Created by Nick Martinson on 1/28/15.
//  Copyright (c) 2015 Nick Martinson. All rights reserved.
//

import UIKit
import Alamofire


class CreateEventViewController: UIViewController, UITextFieldDelegate {
    var eventType = 0
    @IBAction func eventTypeOption(sender: UISegmentedControl) {
        eventType = sender.selectedSegmentIndex
        
    }
    @IBOutlet weak var loc: UILabel!
    @IBOutlet weak var tf: UILabel!
    @IBOutlet weak var eventNameTextField: UITextField!
    @IBOutlet weak var eventlocationTextField: UITextField!
    @IBOutlet weak var eventDate: UIDatePicker!
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        Alamofire.request(.GET,"https://maps.googleapis.com/maps/api/place/autocomplete/json?key=\(APIkeys.googlePlacesKey)&input=\(eventlocationTextField.text!)&location=41.6667,91.5333", parameters: nil ).responseJSON { (_, response, string,_) -> Void in
            println("response:\(string)")
        }
        return true
    }
    /*
    title, host, lat, lon, startTime, endTime

    */
    @IBAction func onAddFriendsPress(sender: AnyObject) {
        
        println(eventType)
        var event = Event(name: eventNameTextField.text ,location: eventlocationTextField.text, date: eventDate.date)
        tf.text = event.EventName
        loc.text = event.EventLocation
        
        let hostId = UserPreferences().getGUID()
        
        
        let date = eventDate.date
        let timestamp = (date.timeIntervalSince1970) * 1000
        let timestampInMs = Int(timestamp)
        
        
        Alamofire.request(.POST,"http://hangout.mybluemix.net/NewEvent", parameters: ["title":eventNameTextField.text, "host":hostId,"lat":41.667,"lon":91.533,"startTime":timestampInMs,"endTime":timestampInMs] ).responseString { (_, response, string,_) -> Void in
            println("response:\(string)")
        }
    }
    
 
}