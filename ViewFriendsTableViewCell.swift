//
//  ViewFriendsTableViewCell.swift
//  All Aboard
//
//  Created by Nick Martinson on 3/28/15.
//  Copyright (c) 2015 Nick Martinson. All rights reserved.
//

import Foundation

class ViewFriendsTableViewCell: UITableViewCell
{
    @IBOutlet weak var nameLabel: UILabel!
    var userID = ""
    var indexPath:NSIndexPath?
    @IBOutlet weak var userPicture: UIImageView!
    
    
    override func awakeFromNib()
    {
    }
    
    /******************************************************************************************
    *   Downloads the users profile pic and shows it
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
}