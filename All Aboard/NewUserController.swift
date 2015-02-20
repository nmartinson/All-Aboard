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
import CryptoSwift

class NewUserController: UIViewController
{
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var realName: UITextField!
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
            if let hashedpass = passwordField.text.sha1() {
                let params = ["username": usernameField.text, "password": hashedpass, "action": "110", "name": realName.text]
                Alamofire.request(.POST, BackendConstants.userURL, parameters: params).responseString { (_, response, string, _) -> Void in
                    println("response: \(string)")
                    if string! == "1100" // creation successful
                    {
                        self.dismissViewControllerAnimated(true, completion: { () -> Void in })
                    }
                    else if string! == "1101" // account already exists
                    {
                        self.errorField.text = "Username already exists"
                    }
                    self.activityIndicator.stopAnimating()
                }
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