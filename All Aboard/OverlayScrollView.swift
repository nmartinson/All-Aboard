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
    
    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView?
    {
        var view2 = super.hitTest(point, withEvent: event)
        return view2 == self ? nil : view2
    }
    
}