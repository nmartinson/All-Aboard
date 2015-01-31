//
//  ViewController.swift
//  All Aboard
//
//  Created by Nick Martinson on 1/28/15.
//  Copyright (c) 2015 Nick Martinson. All rights reserved.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController, FBLoginViewDelegate {

    @IBOutlet weak var FBLoginButton: FBLoginView!
    let url = "http://project-hangout.mybluemix.net/Login?username="
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        FBLoginButton.readPermissions = ["user_friends"]
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
        
        
        var friendsRequest = FBRequest.requestForMyFriends()
        friendsRequest.startWithCompletionHandler { (connection:FBRequestConnection!, result:AnyObject!, error:NSError!) -> Void in
            var resultDict = result as NSDictionary
            println("Result dic: \(resultDict)")
        }
        performSegueWithIdentifier("loggedIn", sender: self)
    }
    
    /******************************************************************************************
    *
    ******************************************************************************************/
    @IBAction func loginButtonPressed(sender: AnyObject)
    {
        println("Standard Login button")
        var urlString = "\(url)nick&password=test"
        Alamofire.request(.GET, urlString, parameters: nil).responseString { (_, response, string, _) -> Void in
            println("response: \(string)")
        }

    }
    
    
    
    

}

