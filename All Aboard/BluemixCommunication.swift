//
//  BluemixCommunication.swift
//  All Aboard
//
//  Created by Nick Martinson on 2/9/15.
//  Copyright (c) 2015 Nick Martinson. All rights reserved.
//

import Foundation
import Alamofire
//import UIKit

class BluemixCommunication: NSObject, NSXMLParserDelegate
{
    var parser = NSXMLParser()
    
    
    func parseStuff()
    {
//        let url = NSURL(string: BackendConstants.recentEvents)
        let url = NSURL(string: "http://images.apple.com/main/rss/hotnews/hotnews.rss")
        parser = NSXMLParser(contentsOfURL: url)!
        parser.delegate = self
        parser.parse()
    }
    
    /******************************************************************************************
    *
    ******************************************************************************************/
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
    
    /******************************************************************************************
    *
    ******************************************************************************************/
    func getEvent(eventID: String, completion:(result: Dictionary<String,AnyObject>?) -> Void)
    {
        var details:Dictionary<String,AnyObject>?
        details = ["error": "", "success": false]
        let route = BackendConstants.eventInfo + eventID
        Alamofire.request(.GET, route, parameters: nil).responseJSON { (_, response, rawJSON, _) -> Void in
            var json = JSON(rawJSON!)
            let eventName = json["eventName"].stringValue
            let eventHost = json["host"].stringValue
            
            completion(result: details)
        }
    }
    
    
    /******************************************************************************************
    *
    ******************************************************************************************/
    func getRecentEvents(count: Int)
    {
        let url = BackendConstants.recentEvents + "\(count)"
        Alamofire.request(.GET, url, parameters: nil).responseJSON { (_, _, response, _) -> Void in

            let json = JSON(response!)
            println("host \(json)")
        }
    }
    
    
    func parser(parser: NSXMLParser!, didStartElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!, attributes attributeDict: [NSObject : AnyObject]!)
    {
        println("elementName: \(elementName)")
    }
    
    func parser(parser: NSXMLParser!, didEndElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!)
    {
//        println()
    }
    
    
    func parser(parser: NSXMLParser!, foundCharacters string: String!)
    {
        println("characters: \(string)")
    }
    
    func parser(parser: NSXMLParser!, parseErrorOccurred parseError: NSError!)
    {
        println(parseError)
    }
    
    
    
    
    
}