//
//  ReturnCodes.swift
//  All Aboard
//
//  Created by Nick Martinson on 2/26/15.
//  Copyright (c) 2015 Nick Martinson. All rights reserved.
//

import Foundation

/******************************************************************************************
*   This class holds the return codes that are used for checking for success or failure
*   upon getting results back from the database
******************************************************************************************/
enum RETURNCODES
{
    // Login
    static let LOGIN_SUCCESS = "1000"
    static let LOGIN_USERNAME_DOES_NOT_EXIST = "1001"
    static let LOGIN_INCORRECT_PASSWORD = "1002"
    
    // Update User
    static let UPDATE_USER_PASSWORD_SUCCESS = "1050"
    static let UPDATE_USER_PASSWORD_FAILURE_INCORRECT_OLD_PASS = "1051"
    static let UPDATE_USER_PASSWORD_FAILURE_UNKNOWN = "1052"
    
    // New User
    static let NEW_USER_SUCCESS = "1100"
    static let NEW_USER_USERNAME_ALREADY_EXISTS = "1101"
    
    // Get User
    static let GET_USER_DOES_NOT_EXIST = "1111"
    
    // New Event
    static let NEW_EVENT_SUCCESS = "1200"
    static let NEW_EVENT_FAILURE = "1201"
    
    // Get Event
    static let GET_EVENT_DOES_NOT_EXIST = "1301"
    
    // Get Most Recent Events
    static let GET_MOST_RECENT_EVENTS_FAILURE = "1311"
    
    // Add friend
    static let ADD_FRIEND_SUCCESS = "1120"
    static let ADD_FRIEND_FAILURE = "1121"
    
    // Remove friend
    static let REMOVE_FRIEND_SUCCESS = "1130"
    static let REMOVE_FRIEND_FAILURE = "1131"
    
    // Get friends
    static let GET_USER_FRIEND_LIST_FAILURE = "1141"
    
    // Search
    static let SEARCH_BY_USERNAME_FAILURE = "1401"
    
    // Invite
    static let INVITE_USER_SUCCESS = "1230"
    static let INVITE_USER_DUPLICATE = "1232"
    static let USER_HAS_NO_INVITES = "1241"
    static let INVITE_ACCEPT_SUCCESS = "1250"
    static let INVITE_ACCEPT_FAILURE = "1251"
    static let INVITE_DECLINE_SUCCES = "1260"
    static let INVITE_DECLINE_FAILURE = "1261"
}