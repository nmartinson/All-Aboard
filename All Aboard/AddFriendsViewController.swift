//
//  AddFriendsViewController.swift
//  All Aboard
//
//  Created by Nick Martinson on 2/22/15.
//  Copyright (c) 2015 Nick Martinson. All rights reserved.
//

import Foundation
import UIKit

class AddFriendsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    @IBOutlet weak var tableView: UITableView!
    
    var contacts:[AnyObject]?
    var people : [SwiftAddressBookPerson]? = []
    var names : [String?]? = []
    var numbers : [Array<String?>?]? = []
    
    override func viewDidLoad()
    {
        // Request contacts access
        swiftAddressBook?.requestAccessWithCompletion({ (success, error) -> Void in
            if success {
                //do something with swiftAddressBook
            }
            else {
                //no success. Optionally evaluate error
            }
        })
        getContacts()

    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell = tableView.dequeueReusableCellWithIdentifier("searchFriendsCell") as SearchFriendsTableViewCell
        cell.nameLabel.text = people![indexPath.row].compositeName
//        cell.phoneNumberLabel.text = numbers![indexPath.row]?.first?
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people!.count
    }
    
    
    func getContacts()
    {
        people = swiftAddressBook?.allPeople //{
//            for person in people {
//                //person.phoneNumbers is a "multivalue" entry
//                //so you get an array of MultivalueEntrys
//                //see MultivalueEntry in SwiftAddressBook
//                println("person \(person.firstName!) \(person.lastName!)")
//                //                println("number \(person.phoneNumbers)")
//                NSLog("%@", person.phoneNumbers!.map( {$0.value} ))
//            }
            tableView.reloadData()
//            println(people.count)
//        }
    }
    
    @IBAction func backButtonPressed(sender: AnyObject)
    {
        dismissViewControllerAnimated(true, completion: nil)
    }
}