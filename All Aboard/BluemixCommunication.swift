//
//  BluemixCommunication.swift
//  All Aboard
//
//  Created by Nick Martinson on 2/9/15.
//  Copyright (c) 2015 Nick Martinson. All rights reserved.
//

import Foundation
import Alamofire

class BluemixCommunication
{
    
    func loginRequest(params: [String:String!], completion:(result: Dictionary<String,AnyObject>?) -> Void)
    {
        var details:Dictionary<String,AnyObject>?
        details = ["error": "", "success": false]
        Alamofire.request(.POST, BackendConstants.loginURL, parameters: params).responseString { (_, response, responseCode, _) -> Void in
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
                details!["success"] = true
            }
            else if code == "1001" // username doesnt exist
            {
                details!["error"] = "Username doesn't exist"
            }
            else if code == "1002" // invalid password
            {
                details!["error"] = "Invalid password"
            }
            completion(result: details)
        }
    }
}