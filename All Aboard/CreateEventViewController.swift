//
//  ViewController.swift
//  All Aboard
//
//  Created by Nick Martinson on 1/28/15.
//  Copyright (c) 2015 Nick Martinson. All rights reserved.
//

import UIKit
import Alamofire

class CreateEventViewController: UIViewController {
    var eventType = 0
    @IBAction func eventTypeOption(sender: UISegmentedControl) {
        eventType = sender.selectedSegmentIndex
        
    }
    @IBOutlet weak var loc: UILabel!
    @IBOutlet weak var tf: UILabel!
    @IBOutlet weak var eventNameTextField: UITextField!
    @IBOutlet weak var eventlocationTextField: UITextField!
    @IBOutlet weak var eventDate: UIDatePicker!
    /*
    title, host, lat, lon, startTime, endTime

    */
    @IBAction func onAddFriendsPress(sender: AnyObject) {
        var event = Event(name: eventNameTextField.text ,location: eventlocationTextField.text, date: eventDate.date)
        tf.text = event.EventName
        loc.text = event.EventLocation
        let hostId = UserPreferences().getGUID()
        let date = NSDate()
       // let formatter = NSDateFormatter()
       // formatter.dateFormat = "yyyy-MM-dd-HH-mm"
       // let time = formatter.stringFromDate(date)
        let timestamp = (date.timeIntervalSince1970) * 1000
        let timestampInMs = Int(timestamp)
        Alamofire.request(.POST,"http://hangout.mybluemix.net/NewEvent", parameters: ["title":eventNameTextField.text, "host":hostId,"lat":41.667,"lon":91.533,"startTime":timestampInMs,"endTime":timestampInMs] ).responseString { (_, response, string,_) -> Void in
            println("response:\(string)")
        }
    }
    
 
}