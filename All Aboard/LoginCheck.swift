//
//  LoginCheck.swift
//  All Aboard
//
//  Created by Nick Martinson on 2/8/15.
//  Copyright (c) 2015 Nick Martinson. All rights reserved.
//

import Foundation

class LoginCheck
{
    func loggedIn(state: Bool)
    {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setBool(state, forKey: "loggedIn")
    }
    
    func loggedInState() -> Bool
    {
        let defaults = NSUserDefaults.standardUserDefaults()
        let state = defaults.boolForKey("loggedIn")
     
        return state
    }
}