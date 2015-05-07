//
//  SearchFriendsViewController.swift
//  All Aboard
//
//  Created by Ian on 2/23/15.
//  Copyright (c) 2015 Nick Martinson. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

/******************************************************************************************
*   This class is for letting a user search for and add new friends.
******************************************************************************************/
class SearchFriendsViewController: UIViewController, UITextFieldDelegate
{
    @IBOutlet weak var addStatus: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var usernameL: UILabel!
    @IBOutlet weak var searchTF: UITextField!
    var searchedUser:User = User(id: "")
    
    override func viewDidLoad()
    {
        addStatus.hidden = true
        addButton.hidden = true
        profilePicture.hidden = true
        profilePicture.layer.cornerRadius = profilePicture.bounds.width/2
        profilePicture.layer.borderColor = UIColor.whiteColor().CGColor
        profilePicture.layer.borderWidth = 6
    }
    
    @IBAction func backButtonHit(sender: AnyObject)
    {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    /******************************************************************************************
    *   This function makes a call to the database checking if a user exists with the userID 
    *   that the user entered. If one does, the users name and profile picture is displayed and
    *   the user has the option to add the friend.
    ******************************************************************************************/
    @IBAction func SearchButtonClicked(sender: AnyObject)
    {
        let searchText = searchTF.text.stringByReplacingOccurrencesOfString(" ", withString: "")
        usernameL.text = ""
        searchTF.text = ""

        if searchText != ""
        {
            addStatus.hidden = true
            searchTF.resignFirstResponder()
            activityIndicator.startAnimating()
            BluemixCommunication().searchForUserByUsername(searchText)
            {
                (user: User?) in
                if user != nil
                {
                    self.usernameL.text = user!.realname as? String
                    self.addButton.hidden = false
                    self.searchedUser = user!
                    AWShelper().downloadThumbnailImageFromS3("profilePictures", file: user!.userid as String, photoNumber: nil)
                    {
                        (image: UIImage?) in
                        self.profilePicture.image = image
                        self.profilePicture.hidden = false
                    }
                }
                else
                {
                    self.usernameL.text = "User not found"
                    self.addButton.hidden = true
                    self.profilePicture.hidden = true
                }
                self.activityIndicator.stopAnimating()
            }
        }
        else
        {
            self.usernameL.text = "Please enter a username"
            self.usernameL.hidden = false
        }
    }
    
    /******************************************************************************************
    *   When the user clicks the add friend button this makes a call to the database adding the 
    *   selected friend to the users friends list
    ******************************************************************************************/
    @IBAction func addButtonClicked(sender: AnyObject)
    {
        let hostId = UserPreferences().getGUID()
        let params = ["action": "112", "userId":hostId, "friendId":searchedUser.userid]
        Alamofire.request(.POST, BackendConstants.userURL, parameters: params ).responseString { (_, response, string,_) -> Void in
            if string == RETURNCODES.ADD_FRIEND_SUCCESS
            {
                self.addStatus.text = "You made a friend!"
                self.addStatus.hidden = false
            }
            else if string == RETURNCODES.ADD_FRIEND_FAILURE
            {
                self.addStatus.hidden = false
                self.addStatus.text = "Error"
            }
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
}