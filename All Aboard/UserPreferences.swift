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
    
    /******************************************************************************************
    *   Sets the logged in state of the current user
    ******************************************************************************************/
    func loggedIn(state: Bool)
    {
        defaults.setBool(state, forKey: "loggedIn")
    }
    
    /******************************************************************************************
    *   Returns the current logged in state of the user
    ******************************************************************************************/
    func loggedInState() -> Bool
    {
        let state = defaults.boolForKey("loggedIn")
     
        return state
    }
    
    /******************************************************************************************
    *   Sets the current users GUID
    ******************************************************************************************/
    func setGUID(guid: String)
    {
        defaults.setObject(guid, forKey: "GUID")
    }
    
    /******************************************************************************************
    *   Returns the current users GUID
    ******************************************************************************************/
    func getGUID() -> String
    {
        let id = defaults.objectForKey("GUID") as String
        return id
    }
    
    /******************************************************************************************
    *   Sets the currents user's full name
    ******************************************************************************************/
    func setName(name: String)
    {
        defaults.setObject(name, forKey: "name")
    }
    
    /******************************************************************************************
    *   Returns the current user's full name
    ******************************************************************************************/
    func getName() -> String
    {
        let name = defaults.objectForKey("name") as String
        return name
    }
    
}