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
        var imageStr = "http://graph.facebook.com/10203626718697502/picture?type=large"

        BluemixCommunication().getLabelImage(imageStr, newImage: userPicture)
        {
            (image: UIImage) in
            self.userPicture.image = image
            self.userPicture.layer.cornerRadius = 23
            self.userPicture.clipsToBounds = true
        }
    }
    
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