//
//  DatePickerController.swift
//  All Aboard
//
//  Created by Nick Martinson on 3/1/15.
//  Copyright (c) 2015 Nick Martinson. All rights reserved.
//

import Foundation
import UIKit

protocol CustomDatePickerDelegate
{
    func doneButtonPressed()
}

class DatePickerController:UIView
{
    
    @IBOutlet weak var datePicker: UIDatePicker!
    var delegate:CustomDatePickerDelegate?
    
    @IBAction func doneButtonPressed(sender: UIButton)
    {
        delegate?.doneButtonPressed()
        println(datePicker.date)
    }
 
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override init()
    {
        super.init()
        let datePickerView = NSBundle.mainBundle().loadNibNamed("DatePickerView", owner: self, options: nil).first as UIView
        
        let height = UIScreen.mainScreen().applicationFrame.height
        let width = UIScreen.mainScreen().applicationFrame.width
        let statusHeight = UIApplication.sharedApplication().statusBarFrame.size.height
        let pickerHeight = height/3
        let size = CGRectMake(0, height-pickerHeight+statusHeight, width, pickerHeight)
        super.frame = size
        datePickerView.frame = CGRectMake(0, 0, frame.width, frame.height)
        self.addSubview(datePickerView)
    }

    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
}