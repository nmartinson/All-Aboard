//
//  NewUserController.swift
//  All Aboard
//
//  Created by Nick Martinson on 2/2/15.
//  Copyright (c) 2015 Nick Martinson. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class NewUserController: UIViewController
{
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var errorField: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBAction func submitButtonPressed(sender: AnyObject)
    {
        if usernameField.text == "" || passwordField.text == "" || confirmPasswordField.text == ""
        {
            errorField.text = "Missing input"
        }
        else if passwordField.text != confirmPasswordField.text
        {
            errorField.text = "Passwords don't match"
        }
        else
        {
            activityIndicator.startAnimating()
            Alamofire.request(.POST, BackendConstants.newUserURL, parameters: ["username": usernameField.text, "password": passwordField.text]).responseString { (_, response, string, _) -> Void in
                println("response: \(string)")
                if string! == "1100\n" // creation successful
                {
                    self.dismissViewControllerAnimated(true, completion: { () -> Void in })
                }
                else if string! == "1101\n" // account already exists
                {
                    self.errorField.text = "Username already exists"
                }
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    @IBAction func cancelButtonPressed(sender: AnyObject)
    {
        dismissViewControllerAnimated(true, completion: { () -> Void in })
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        textField.resignFirstResponder()
        return true;
    }
    
}