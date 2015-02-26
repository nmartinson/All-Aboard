//
//  BluemixCommunication.swift
//  All Aboard
//
//  Created by Nick Martinson on 2/9/15.
//  Copyright (c) 2015 Nick Martinson. All rights reserved.
//

import Foundation
import Alamofire

class BluemixCommunication: NSObject
{
    
    /******************************************************************************************
    *
    ******************************************************************************************/
    func loginRequest(params: [String:String!], completion:(result: Dictionary<String,AnyObject>?) -> Void)
    {
        var details:Dictionary<String,AnyObject>?
        details = ["error": "", "success": false, "name": ""]
        Alamofire.request(.POST, BackendConstants.userURL, parameters: params).responseString { (_, response, responseCode, _) -> Void in
            println(responseCode)
            var responseArray = Array(responseCode!)

            let stringArray = responseCode!.componentsSeparatedByString(",")
            let code = stringArray[0]
            let GUID = stringArray[1]
            let name = stringArray[2]
            println(stringArray)
            if code == "1000" // successful login
            {
                UserPreferences().setGUID(GUID)
                UserPreferences().loggedIn(true)
                details!["success"] = true
                details!["name"] = name
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
    
    /******************************************************************************************
    *
    ******************************************************************************************/
    func getEvent(eventID: String, completion:(result: Event) -> Void)
    {
        var details:Dictionary<String,AnyObject>?
        details = ["error": "", "success": false]
        let params = ["action": "130", "eventId": eventID]
        let route = BackendConstants.eventURL
        Alamofire.request(.GET, route, parameters: params).responseJSON { (_, response, rawJSON, _) -> Void in
            var json = JSON(rawJSON!)
            println("GET EVENT \n \(json)")
            
            let title = json[0]["title"].stringValue
            let hostID = json[0]["hostId"].stringValue
            let endTime = json[0]["endTime"].intValue
            let id = json[0]["id"].stringValue
            let long = CLLocationDegrees(json[0]["lon"].floatValue)
            let lat = CLLocationDegrees(json[0]["lat"].floatValue)
            let startTime = json[0]["startTime"].intValue
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            let event = Event(name: title, location: "location", coordinates: coordinate, hostID: hostID, date: NSDate(), eventID: id)
        
            completion(result: event)
        }
    }
    
    
    /******************************************************************************************
    *
    ******************************************************************************************/
    func getRecentEvents(count: Int, completion:(result: [Event]) -> Void)
    {
        let eventCount = String(count)
        let params = ["action": "131", "count": eventCount]
        let route = BackendConstants.eventURL
        
        Alamofire.request(.GET, route, parameters: params).responseJSON { (_, _, response, _) -> Void in
            let json = JSON(response!)
//            println("GET RECENT EVENTS\n \(json)")
            var events:[Event] = []
            for(var i = 0; i < json.count; i++)
            {
                let title = json[i]["event"]["title"].stringValue
                let hostID = json[i]["event"]["hostId"].stringValue
                let endTime = json[i]["event"]["endTime"].intValue
                let id = json[i]["event"]["id"].stringValue
                let long = CLLocationDegrees(json[i]["event"]["lon"].floatValue)
                let lat = CLLocationDegrees(json[i]["event"]["lat"].floatValue)
                let startTime = json[i]["event"]["startTime"].intValue
                let userRealName = json[i]["user"]["name"].stringValue
                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                let event = Event(name: title, location: "location", coordinates: coordinate, hostID: hostID, date: NSDate(), eventID: id, hostName: userRealName)
                
                events.append(event)
            }
        
            completion(result: events)
        }
    }
    
    /******************************************************************************************
    *
    ******************************************************************************************/
    func getUserInfoByID(userID: String, completion: (user: Dictionary<String,AnyObject>?) -> Void)
    {
        let params = ["action": "111", "userId": userID]
        let route = BackendConstants.userURL
        
        Alamofire.request(.GET, route, parameters: params).responseJSON { (_, _, response, _) -> Void in
            var userInfo:Dictionary<String,AnyObject>?
            userInfo = ["name": "", "username": "", "id": ""]

            let json = JSON(response!)
//            println("USER INFO\n \(json)")
            userInfo!["username"] = json["username"].stringValue
            userInfo!["id"] = json["id"].stringValue
            userInfo!["name"] = json["name"].stringValue
            
            completion(user: userInfo)
        }
    }
    
    func getFriendsList(userID:String, completion: (result: [Dictionary<String,AnyObject>?]) -> Void)
    {
        let params = ["action": "114","userId": userID]
        let route = BackendConstants.userURL
        
        Alamofire.request(.GET, route, parameters: params).responseJSON { (_, _, response, _) -> Void in
            let json = JSON(response!)
            println(json)
            var userInfo:Dictionary<String,AnyObject>?
            userInfo = ["name": "", "username": "", "id": ""]
            //            println("GET RECENT EVENTS\n \(json)")
            var friends:[Dictionary<String,AnyObject>?] = []
            for(var i = 0; i < json.count; i++)
            {
                userInfo!["username"] = json[i]["user"]["username"].stringValue
                userInfo!["id"] = json[i]["user"]["id"].stringValue
                userInfo!["name"] = json[i]["user"]["name"].stringValue
                
                friends.append(userInfo)
            }
            
            completion(result: friends)
        }
    }
    
    
    
    
    /**

    Friends List Notes: 
        Add: 112
                params: userId, friendId
        
        Remove: 113
                params: userId, friendId
    
        Get friends list: 114
                params: userId
    
        Searching by Username: 140
                params: username


    **/
    
    
    
    
    
    
}