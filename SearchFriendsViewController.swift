//
//  SearchFriendsViewController.swift
//  All Aboard
//
//  Created by Ian on 2/23/15.
//  Copyright (c) 2015 Nick Martinson. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class SearchFriendsViewController: UIViewController {
    
    @IBOutlet weak var idL: UILabel!
    
    @IBOutlet weak var usernameL: UILabel!
    @IBOutlet weak var searchTF: UITextField!
    
    var searchedUser:User = User(id: "")
    
    @IBAction func SearchButtonClicked(sender: AnyObject) {
        let hostId = UserPreferences().getGUID()
        println(hostId)
        let params = ["action": "140", "username":self.searchTF.text]
        Alamofire.request(.GET, BackendConstants.userURL, parameters: params ).responseJSON { (_, _, response,_) -> Void in
            println("response:\(response)")
            let json = JSON(response!)
            let name = json["username"].stringValue
            let userid = json["id"].stringValue
            let personname = json["name"].stringValue
            self.searchedUser = User(name:name,id:userid, real:personname)
        }
        
    }
    @IBAction func addButtonClicked(sender: AnyObject) {
        
        
        let hostId = UserPreferences().getGUID()
        println(hostId)
        let params = ["action": "112", "userId":hostId, "friendId":searchedUser.userid]
        Alamofire.request(.POST, BackendConstants.userURL, parameters: params ).responseString { (_, response, string,_) -> Void in
            println("response:\(string)")
            
        }
        
        
    }
}