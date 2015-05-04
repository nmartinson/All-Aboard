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