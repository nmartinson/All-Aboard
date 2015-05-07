//
//  Helper.swift
//  All Aboard
//
//  Created by Nick Martinson on 3/5/15.
//  Copyright (c) 2015 Nick Martinson. All rights reserved.
//

import Foundation
import Alamofire

/******************************************************************************************
*   This class is a helper that performs a few common functions
******************************************************************************************/
class Helper
{
    /******************************************************************************************
    *   This function formats a date object into a string format that we want
    ******************************************************************************************/
    func formatDateString(date: NSDate) -> String
    {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "E, MMMM d, yyyy h:mm a"
        let dateString = formatter.stringFromDate(date)
        return dateString
    }
    
    /******************************************************************************************
    *   Dynamically get an image over the network and place it in an imageview
    ******************************************************************************************/
    func getLabelImage(imageStr: String, newImage: UIImageView)
    {
        Alamofire.request(.GET,imageStr).responseImage({ (request, _, image, error) -> Void in
            if error == nil && image != nil{
                newImage.image = image
            }
        })
    }
}