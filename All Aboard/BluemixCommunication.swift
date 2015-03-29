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
            
            let stringArray = responseCode!.componentsSeparatedByString(",")
            let code = stringArray[0]

            if code == RETURNCODES.LOGIN_SUCCESS // "1000" // successful login
            {
                var responseArray = Array(responseCode!)

                let GUID = stringArray[1]
                let name = stringArray[2]
                UserPreferences().setGUID(GUID)
                UserPreferences().loggedIn(true)
                details!["success"] = true
                details!["name"] = name
            }
            else if code == RETURNCODES.LOGIN_USERNAME_DOES_NOT_EXIST  //  "1001" // username doesnt exist
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
            
            let location = json["event"]["locationTitle"].stringValue
            let title = json["event"]["title"].stringValue
            let hostID = json["event"]["hostId"].stringValue
            let endTime = json["event"]["endTime"].intValue
            let endDate = NSDate(timeIntervalSince1970: NSTimeInterval(endTime)/1000)

            let id = json["event"]["id"].stringValue
            let long = CLLocationDegrees(json["event"]["lon"].floatValue)
            let lat = CLLocationDegrees(json["event"]["lat"].floatValue)
            let startTime = json["event"]["startTime"].intValue
            let startDate = NSDate(timeIntervalSince1970: NSTimeInterval(startTime)/1000)

            let inviteList = json["event"]["inviteList"].stringValue
            let inviteListArray = inviteList.componentsSeparatedByString(",")
            let username = json["user"]["username"].stringValue
            let userID = json["user"]["id"].stringValue
            let userRealName = json["user"]["name"].stringValue
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            
            let event = Event(name: title, location: location, coordinates: coordinate, hostID: hostID, eventStartDate: startDate, eventEndDate: endDate, eventID: id, hostName: userRealName, inviteList: inviteListArray)
        
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
        
        Alamofire.request(.GET, route, parameters: params).responseJSON { (_, stuff, response, _) -> Void in
//            println(response)
            if response != nil
            {
                let json = JSON(response!)
                var events:[Event] = []
                for(var i = 0; i < json.count; i++)
                {
                    let title = json[i]["event"]["title"].stringValue
                    let hostID = json[i]["event"]["hostId"].stringValue
                    let endTime = json[i]["event"]["endTime"].intValue
                    let location = json[i]["event"]["locationTitle"].stringValue
                    let endDate = NSDate(timeIntervalSince1970: NSTimeInterval(endTime)/1000)

                    let id = json[i]["event"]["id"].stringValue
                    let long = CLLocationDegrees(json[i]["event"]["lon"].floatValue)
                    let lat = CLLocationDegrees(json[i]["event"]["lat"].floatValue)
                    let startTime = json[i]["event"]["startTime"].intValue
                    
                    let startDate = NSDate(timeIntervalSince1970: NSTimeInterval(startTime)/1000)
                    
                    let inviteList = json[i]["event"]["inviteList"].stringValue
                    let inviteListArray = inviteList.componentsSeparatedByString(",")
                    
                    let userRealName = json[i]["user"]["name"].stringValue
                    let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                    let event = Event(name: title, location: location, coordinates: coordinate, hostID: hostID, eventStartDate: startDate, eventEndDate: endDate, eventID: id, hostName: userRealName, inviteList: inviteListArray)
                    
                    events.append(event)
                }
                completion(result: events)
            }
        }
    }
    
    
    /******************************************************************************************
    *
    ******************************************************************************************/
    func getUserInviteList(userID: String, completion:(result: [Event]) -> Void)
    {
        let params = ["action": ACTIONCODES.GET_USER_INVITES, "userId": userID]
        let route = BackendConstants.userURL
        
        Alamofire.request(.GET, route, parameters: params).responseJSON { (_, stuff, response, _) -> Void in
            if response != nil
            {
                let code = JSON(response!).stringValue

                if code != "1241"
                {
                    let json = JSON(response!)
                    var events:[Event] = []
                    for(var i = 0; i < json.count; i++)
                    {
                        let title = json[i]["event"]["title"].stringValue
                        let hostID = json[i]["event"]["hostId"].stringValue
                        let endTime = json[i]["event"]["endTime"].intValue
                        let location = json[i]["event"]["locationTitle"].stringValue
                        let endDate = NSDate(timeIntervalSince1970: NSTimeInterval(endTime)/1000)
                        
                        let id = json[i]["event"]["id"].stringValue
                        let long = CLLocationDegrees(json[i]["event"]["lon"].floatValue)
                        let lat = CLLocationDegrees(json[i]["event"]["lat"].floatValue)
                        let startTime = json[i]["event"]["startTime"].intValue
                        
                        let startDate = NSDate(timeIntervalSince1970: NSTimeInterval(startTime)/1000)
                        
                        let inviteList = json["event"]["inviteList"].stringValue
                        let inviteListArray = inviteList.componentsSeparatedByString(",")
                        
                        let userRealName = json[i]["user"]["name"].stringValue
                        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                        let event = Event(name: title, location: location, coordinates: coordinate, hostID: hostID, eventStartDate: startDate, eventEndDate: endDate, eventID: id, hostName: userRealName, inviteList: inviteListArray)
                        events.append(event)
                    }
                    completion(result: events)
                }
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
                println("USER INFO\n \(json)")
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
    
    /******************************************************************************************
    *
    ******************************************************************************************/
    func getEventAttendees(eventID:String, completion: (attendees: [User]) -> Void)
    {
        let params = ["action": ACTIONCODES.EVENT_ATTENDEES,"eventId": eventID]
        let route = BackendConstants.userURL
        
        Alamofire.request(.GET, route, parameters: params).responseJSON { (_, _, response, _) -> Void in
//             println(response)
            if response != nil
            {
                let json = JSON(response!)
                var attendeeArray:[User] = []

                for(var i = 0; i < json.count; i++)
                {
                    let name = json[i]["username"].stringValue
                    let id = json[i]["id"].stringValue
                    let realName = json[i]["name"].stringValue
                    
                    attendeeArray.append(User(name: name, id: id, real: realName))
                }
                completion(attendees: attendeeArray)
            }
            else
            {
                completion(attendees: [])
            }
        }
    }

    /******************************************************************************************
    *
    ******************************************************************************************/
    func denyEventInvite(eventID:String, userID: String, completion: (attendees: [User]) -> Void)
    {
        let params = ["action": ACTIONCODES.DECLINE_INVITE,"eventId": eventID, "userId": userID]
        let route = BackendConstants.userURL
        
        Alamofire.request(.GET, route, parameters: params).responseString { (_, _, response, _) -> Void in
            //0 success
            // 1 failure
            println("DENY \(response)")
        }
    }
    
    /******************************************************************************************
    *
    ******************************************************************************************/
    func acceptEventInvite(eventID:String, userID: String, completion: (attendees: [User]) -> Void)
    {
        let params = ["action": ACTIONCODES.DECLINE_INVITE,"eventId": eventID, "userId": userID]
        let route = BackendConstants.userURL
        
        Alamofire.request(.GET, route, parameters: params).responseString { (_, _, response, _) -> Void in
            //0 success
            // 1 failure
            println("ACCEPT \(response)")
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
    func searchForUserByUsername(username: String, completion: (result: User?) -> Void)
    {
        let params = ["action": "140", "username":username]
        Alamofire.request(.GET, BackendConstants.userURL, parameters: params ).responseJSON { (_, _, response,_) -> Void in
            println("response:\(response)")
            if response != nil
            {
                let json = JSON(response!)
                let name = json["username"].stringValue
                let userid = json["id"].stringValue
                let personname = json["name"].stringValue
                let user = User(name: name, id: userid, real: personname)
                completion(result: user)
            }
            else
            {
                completion(result: nil)
//                self.usernameL.text = "User not found"
//                self.addButton.hidden = true
            }
        }
   
    }
    
    
    
    
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