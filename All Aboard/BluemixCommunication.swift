//
//  BluemixCommunication.swift
//  All Aboard
//
//  Created by Nick Martinson on 2/9/15.
//  Copyright (c) 2015 Nick Martinson. All rights reserved.
//

import Foundation
import Alamofire

/******************************************************************************************
*   This class is responsible for all communication with the bluemix backend database
******************************************************************************************/
class BluemixCommunication: NSObject
{
    /******************************************************************************************
    *   This function performs the login and returns a success/failure message
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
    *   This function gets the event information for an event with the specified ID
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
    *   This function gets Event details for the most recent events for number of events that
    *   is passed in for the count.
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
    *   This function gets the list of events that the user has been invited to
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
    *   This function gets information about a User for the userID that is passed in
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
    *   This function gets the users friends list
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
    *   This function gets the attendees for the event specified by the eventID
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
    *   This function tells the backend that the user has denied the specified event
    ******************************************************************************************/
    func denyEventInvite(eventID:String, userID: String, completion: (result: String) -> Void)
    {
        let params = ["action": ACTIONCODES.DECLINE_INVITE,"eventId": eventID, "userId": userID]
        let route = BackendConstants.userURL
        
        Alamofire.request(.POST, route, parameters: params).responseString { (_, _, response, _) -> Void in
            //0 success
            // 1 failure
            println("DENY \(response)")
        }
    }
    
    /******************************************************************************************
    *   This function tells the backend that the user has accepted the specified event
    ******************************************************************************************/
    func acceptEventInvite(eventID:String, userID: String, completion: (result: String) -> Void)
    {
        let params = ["action": ACTIONCODES.ACCEPT_INVITE,"eventId": eventID, "userId": userID]
        let route = BackendConstants.userURL
        
        Alamofire.request(.POST, route, parameters: params).responseString { (_, _, response, _) -> Void in
            println("ACCEPT \(response)")
            completion(result: response!)
        }
    }
    
    /******************************************************************************************
    *   This function searches the database for a user with the specified username
    ******************************************************************************************/
    func searchForUserByUsername(username: String, completion: (result: User?) -> Void)
    {
        let params = ["action": "140", "username":username]
        Alamofire.request(.GET, BackendConstants.userURL, parameters: params ).responseJSON { (_, _, response,_) -> Void in
            if response?.stringValue == RETURNCODES.SEARCH_BY_USERNAME_FAILURE
            {
                completion(result: nil)
            }
            else
            {
                let json = JSON(response!)
                let name = json["username"].stringValue
                let userid = json["id"].stringValue
                let personname = json["name"].stringValue
                let user = User(name: name, id: userid, real: personname)
                completion(result: user)
            }
        }
   
    }
    
    
    
    /******************************************************************************************
    *   This function creates an event in the database with the specified params
    ******************************************************************************************/
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
    
}