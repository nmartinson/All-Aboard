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
            if code == RETURNCODES.LOGIN_SUCCESS // "1000" // successful login
            {
                UserPreferences().setGUID(GUID)
                UserPreferences().loggedIn(true)
                details!["success"] = true
                details!["name"] = name
            }
            else if code == RETURNCODES.GET_USER_DOES_NOT_EXIST  //  "1001" // username doesnt exist
            {
                details!["error"] = "Username doesn't exist"
            }
            else if code == RETURNCODES.LOGIN_INCORRECT_PASSWORD //"1002" // invalid password
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
        let params = ["action": ACTIONCODES.GET_EVENT_INFO, "eventId": eventID]
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
        let params = ["action": ACTIONCODES.GET_RECENT_EVENTS, "count": eventCount]
        let route = BackendConstants.eventURL
        
        Alamofire.request(.GET, route, parameters: params).responseJSON { (_, _, response, _) -> Void in
            if response != nil
            {
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
    }
    
    /******************************************************************************************
    *
    ******************************************************************************************/
    func getUserInfoByID(userID: String, completion: (user: Dictionary<String,AnyObject>?) -> Void)
    {
        let params = ["action": ACTIONCODES.GET_USER_INFO, "userId": userID]
        let route = BackendConstants.userURL
        
        Alamofire.request(.GET, route, parameters: params).responseJSON { (_, _, response, _) -> Void in
            var userInfo:Dictionary<String,AnyObject>?
            userInfo = ["name": "", "username": "", "id": ""]
            if response != nil
            {
                let json = JSON(response!)
    //            println("USER INFO\n \(json)")
                userInfo!["username"] = json["username"].stringValue
                userInfo!["id"] = json["id"].stringValue
                userInfo!["name"] = json["name"].stringValue
                
                completion(user: userInfo)
            }
        }
    }
    
    /******************************************************************************************
    *
    ******************************************************************************************/
    func getFriendsList(userID:String, completion: (result: [User]) -> Void)
    {
        let params = ["action": "114","userId": userID]
        let route = BackendConstants.userURL
        
        Alamofire.request(.GET, route, parameters: params).responseJSON { (_, _, response, _) -> Void in
            let json = JSON(response!)
           // println(json)
            var userInfo:Dictionary<String,AnyObject>?
            userInfo = ["name": "", "username": "", "id": ""]
            //            println("GET RECENT EVENTS\n \(json)")
            var friendsArray:[User] = []
            var friends:[Dictionary<String,AnyObject>?] = []
            for(var i = 0; i < json.count; i++)
            {
                userInfo!["username"] = json[i]["username"].stringValue
                userInfo!["id"] = json[i]["id"].stringValue
                userInfo!["name"] = json[i]["name"].stringValue
                
                let name = json[i]["username"].stringValue
                let id = json[i]["id"].stringValue
                let realName = json[i]["name"].stringValue
                
                friendsArray.append(User(name: name, id: id, real: realName))
                friends.append(userInfo!)
            }
            
            completion(result: friendsArray)
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
    
    
    
    func createEvent(params: Dictionary<String,AnyObject>)
    {
        
        Alamofire.request(.POST, BackendConstants.eventURL, parameters: params ).responseString { (_, response, string,_) -> Void in
            println("response:\(string)")
        }
    }


    
    
    /******************************************************************************************
    * Allows for placing an image in a dynamically created imageview
    ******************************************************************************************/
    func getLabelImage(imageStr: String, newImage: UIImageView, completion: (result: UIImage) -> Void)
    {
        Alamofire.request(.GET,imageStr).responseImage({ (request, _, image, error) -> Void in
            if error == nil && image != nil{
//                newImage.image = image
                completion(result: image!)
            }
        })
    }
    
    /******************************************************************************************
    *
    ******************************************************************************************/
    func sendImage(image: UIImage)
    {
//        var imageData = UIImagePNGRepresentation(image)
        var imageData = UIImageJPEGRepresentation(image, 0.5)
        let base64image = imageData.base64EncodedStringWithOptions(.allZeros)
        let params = ["encodedImage": base64image]
        
        Alamofire.request(.POST, BackendConstants.testURL, parameters: params).responseString { (_, response, responseCode, _) -> Void in
            println(responseCode)
        }
        
    }
    
    /******************************************************************************************
    *
    ******************************************************************************************/
    func getImage(completion: (image: UIImage?) -> Void)
    {
        
        Alamofire.request(.GET, BackendConstants.testURL, parameters: nil).responseString { (_, response, imageString, _) -> Void in
            
            let decodedData = NSData(base64EncodedString: imageString!, options: NSDataBase64DecodingOptions(rawValue: 0))
            var decodedImage = UIImage(data: decodedData!)
            completion(image: decodedImage)
        }


    }
    
}