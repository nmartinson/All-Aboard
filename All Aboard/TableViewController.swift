//
//  TableViewController.swift
//  All Aboard
//
//  Created by Nick Martinson on 1/28/15.
//  Copyright (c) 2015 Nick Martinson. All rights reserved.
//

import Foundation
import UIKit

class TableViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate
{
    
    override func viewWillAppear(animated: Bool)
    {
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        return UITableViewCell()
    }
}