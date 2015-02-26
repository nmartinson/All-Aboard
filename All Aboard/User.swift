//
//  User.swift
//  All Aboard
//
//  Created by Ian on 2/23/15.
//  Copyright (c) 2015 Nick Martinson. All rights reserved.
//

import Foundation

class User {
    var username:NSString?
    var userid:NSString
    var realname:NSString?
    
    init(name:NSString, id:NSString, real:NSString)
    {
        self.username = name
        self.userid = id
        self.realname = real
        
    }
    
    init(name:NSString, id:NSString)
    {
        self.username = name
        self.userid = id
    }
    
    init(id:NSString)
    {
        self.userid = id
    }
    
    init(real:NSString, id:NSString)
    {
        self.userid = id
        self.realname = real
    }
    
}