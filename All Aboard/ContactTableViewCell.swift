//
//  ContactTableViewCell.swift
//  All Aboard
//
//  Created by Nick Martinson on 2/22/15.
//  Copyright (c) 2015 Nick Martinson. All rights reserved.
//

import Foundation


protocol checkBoxCellDelegate
{
    func didSelectCheckbox(userID: String, indexPath:NSIndexPath, selected:Bool)
}

/******************************************************************************************
*   This class is an extension of UITableViewCell to make a custom cell for presenting
*   the contacts list
******************************************************************************************/
class ContactTableViewCell: UITableViewCell
{
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addFriendButton: UIButton!
    var userID = ""
    var checkBoxSelected = false
    var delegate:checkBoxCellDelegate?
    var indexPath:NSIndexPath?
    @IBOutlet weak var userPicture: UIImageView!
    
    
    override func awakeFromNib()
    {
    }
    
    /******************************************************************************************
    *   Downloads the users profile picture and puts it in the tableviewcell
    ******************************************************************************************/
    func setProfilePicture(GUID: String)
    {
        AWShelper().downloadImageFromS3("profilePictures", file: GUID, photoNumber: nil)
        {
            (image: UIImage?) in
            self.userPicture.image = image
            self.userPicture.layer.cornerRadius = 23
            self.userPicture.clipsToBounds = true
        }
    }
    
    /******************************************************************************************
    *   Highlights the cell and fills in the checkbox when a user is selected to be invited
    ******************************************************************************************/
    @IBAction func addFriendButtonPressed(sender: AnyObject)
    {
        checkBoxSelected = !checkBoxSelected
        delegate?.didSelectCheckbox(userID, indexPath: indexPath!, selected: checkBoxSelected)
        
        if checkBoxSelected
        {
            addFriendButton.setImage(UIImage(named: "cb_dark_on.png"), forState: .Normal)
        }
        else
        {
            addFriendButton.setImage(UIImage(named: "cb_dark_off.png"), forState: .Normal)
        }
    }
    
}