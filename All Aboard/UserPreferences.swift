//
//  LoginCheck.swift
//  All Aboard
//
//  Created by Nick Martinson on 2/8/15.
//  Copyright (c) 2015 Nick Martinson. All rights reserved.
//

import Foundation

class UserPreferences
{
    let defaults = NSUserDefaults.standardUserDefaults()
    func loggedIn(state: Bool)
    {
        defaults.setBool(state, forKey: "loggedIn")
    }
    
    func loggedInState() -> Bool
    {
        let state = defaults.boolForKey("loggedIn")
     
        return state
    }
    
    func setGUID(guid: String)
    {
        defaults.setObject(guid, forKey: "GUID")
    }
    
    func getGUID() -> String
    {
        let id = defaults.objectForKey("GUID") as String
        return id
    }
    
}