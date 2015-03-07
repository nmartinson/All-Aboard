//
//  OverlayScrollView.swift
//  All Aboard
//
//  Created by Nick Martinson on 3/7/15.
//  Copyright (c) 2015 Nick Martinson. All rights reserved.
//

import Foundation
import UIKit

class OverlayScrollView: UIScrollView
{
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent)
    {
        if !self.dragging
        {
            self.nextResponder()?.touchesBegan(touches, withEvent: event)
            println("not me")
        }
        println("Touches began override")
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        if !self.dragging
        {
            self.nextResponder()?.touchesMoved(touches, withEvent: event)
        }
    }
    
}