//
//  ActionCodes.swift
//  All Aboard
//
//  Created by Nick Martinson on 2/26/15.
//  Copyright (c) 2015 Nick Martinson. All rights reserved.
//

import Foundation

/******************************************************************************************
*  This class holds the action codes that are used when performing certain operations 
*   on the database
******************************************************************************************/
enum ACTIONCODES
{
    // user
    static let NEW_USER = "110"
    static let UPDATE_USER_PASSWORD = "105"
    static let USER_LOGIN = "100"
    static let GET_USER_INFO = "111"
    static let GET_USER_INVITES = "124"
    static let UPDATE_PASSWORD = "105"
    static let EVENT_ATTENDEES = "128"

    
    // Event codes
    static let NEW_EVENT = "120"
    static let GET_EVENT_INFO = "130"
    static let GET_RECENT_EVENTS = "131"
    static let ADD_FRIEND = "112"
    static let REMOVE_FRIEND = "113"
    static let SEARCH_BY_USERNAME = "140"
    static let GET_USER_FRIEND_LIST = "114"
    
    // Invites
    static let INVITE_USER = "123"
    static let ACCEPT_INVITE = "125"
    static let DECLINE_INVITE = "126"
}