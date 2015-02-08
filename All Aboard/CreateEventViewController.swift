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
    
    @IBAction func onAddFriendsPress(sender: AnyObject) {
        var event = Event(name: eventNameTextField.text ,location: eventlocationTextField.text, date: eventDate.date)
        tf.text = event.EventName
        loc.text = event.EventLocation
       // Alamofire.request(.POST,"url", parameters: ["location":eventlocationTextField.text, "name":eventNameTextField.text,"date":eventDate] ).responseString { (_, response, string,_) -> Void in
       //     println("response:\(string)")
       // }
    }
    
    
}