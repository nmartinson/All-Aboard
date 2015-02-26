//
//  ViewFriendsViewController.swift
//  All Aboard
//
//  Created by Ian on 2/23/15.
//  Copyright (c) 2015 Nick Martinson. All rights reserved.
//

import Foundation
import UIKit

class ViewFriendsViewController: UIViewController {
    
    var friendsL:[Dictionary<String,AnyObject>?] = []

    override func viewDidLoad() {
        BluemixCommunication().getFriendsList(UserPreferences().getGUID() )
        {
            (results: [Dictionary<String,AnyObject>?]) in
            self.friendsL = results
        }
        
        println(self.friendsL)
    }
    
}