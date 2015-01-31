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
    
    @IBOutlet weak var loc: UILabel!
    @IBOutlet weak var tf: UILabel!
    @IBOutlet weak var eventNameTextField: UITextField!
    @IBOutlet weak var eventlocationTextField: UITextField!
    @IBOutlet weak var eventDate: UIDatePicker!
    
    @IBAction func onAddFriendsPress(sender: AnyObject) {
        var event = Event(name: eventNameTextField.text ,location: eventlocationTextField.text, date: eventDate.date)
        tf.text = event.EventName
        loc.text = event.EventLocation
    }
    
    
}