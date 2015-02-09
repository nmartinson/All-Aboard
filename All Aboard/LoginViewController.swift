//
//  ViewController.swift
//  All Aboard
//
//  Created by Nick Martinson on 1/28/15.
//  Copyright (c) 2015 Nick Martinson. All rights reserved.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController, FBLoginViewDelegate
{

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var errorField: UILabel!
    @IBOutlet weak var FBLoginButton: FBLoginView!
    let url = "http://project-hangout.mybluemix.net/"
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        FBLoginButton.readPermissions = ["user_friends"]
    }
    
    override func viewDidAppear(animated: Bool)
    {
        // If a user didn't log out previously, they will automatically be logged in
        println("logged in state: \(UserPreferences().loggedInState())")
        if UserPreferences().loggedInState()
        {
            performSegueWithIdentifier("loggedIn", sender: self)
        }
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    /******************************************************************************************
    *
    ******************************************************************************************/
    func loginViewShowingLoggedOutUser(loginView: FBLoginView!)
    {
        println("Logged out")
    }
    
    /******************************************************************************************
    *
    ******************************************************************************************/
    func loginViewShowingLoggedInUser(loginView: FBLoginView!)
    {
//        FBRequest.requestForMe().startWithCompletionHandler { (connection:FBRequestConnection!, result:AnyObject!, error:NSError!) -> Void in
//                println("Result: \(result)")
//        }
        
        var friendsRequest = FBRequest.requestForMyFriends()
        friendsRequest.startWithCompletionHandler { (connection:FBRequestConnection!, result:AnyObject!, error:NSError!) -> Void in
            var resultDict = result as NSDictionary
            let jsonData = JSON(result)
            let data = jsonData["data"]
            for(var i = 0; i < data.count; i++)
            {
                let firstName = data[i]["first_name"].stringValue
                let lastName = data[i]["last_name"].stringValue
                let user_id = data[i]["id"].stringValue
                println("name \(firstName) \(lastName), id \(user_id)")
                
                // Sent the userID to the backend
//                Alamofire.request(.POST, BackendConstants.loginURL, parameters: ["username": user_id, "password": ""]).responseString {(_,response, responseCode,_) -> Void in
//                    
//                }
            }
        }
        performSegueWithIdentifier("loggedIn", sender: self)
    }
    
    
    @IBAction func createAccountButtonPressed(sender: AnyObject)
    {
        performSegueWithIdentifier("createAccountSegue", sender: self)
    }
    
    
    
    /******************************************************************************************
    *
    ******************************************************************************************/
    @IBAction func loginButtonPressed(sender: AnyObject)
    {
        let username = usernameField.text
        let password = passwordField.text
        if username == "" || password == ""
        {
            errorField.text = "Missing input"
        }
        else
        {
            activityIndicator.startAnimating()

            Alamofire.request(.POST, BackendConstants.loginURL, parameters: ["username": username, "password": password]).responseString { (_, response, responseCode, _) -> Void in
                var responseArray = Array(responseCode!)
                
                let code:String = "\(responseArray[0])\(responseArray[1])\(responseArray[2])\(responseArray[3])"
                
                var GUID:String = ""
                for(var i = 5; i < responseArray.count; i++)
                {
                    GUID = "\(GUID)" + String(responseArray[i])
                }
                
                if code == "1000" // successful login
                {
                    UserPreferences().setGUID(GUID)
                    UserPreferences().loggedIn(true)
                    self.performSegueWithIdentifier("loggedIn", sender: self)
                }
                else if code == "1001" // username doesnt exist
                {
                    self.errorField.text = "Username doesn't exist"
                }
                else if code == "1002" // invalid password
                {
                    self.errorField.text = "Invalid password"
                }
                self.activityIndicator.stopAnimating()
            }
        }

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "createAccountSegue"
        {
            let controller = segue.destinationViewController as NewUserController
        }
    }
    

}

