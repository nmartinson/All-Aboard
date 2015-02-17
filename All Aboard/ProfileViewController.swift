//
//  ViewController.swift
//  All Aboard
//
//  Created by Nick Martinson on 1/28/15.
//  Copyright (c) 2015 Nick Martinson. All rights reserved.
//

import UIKit
import Alamofire

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profilePic: UIImageView!
    
    override func viewDidLoad() {
        let eepupID = "10153524130878066"
        var imageStr = "http://graph.facebook.com/\(eepupID)/picture?type=large"
        getLabelImage(imageStr, newImage: profilePic)
    }
    
    func getLabelImage(imageStr: String, newImage: UIImageView)
    {
        Alamofire.request(.GET,imageStr).responseImage({ (request, _, image, error) -> Void in
            if error == nil && image != nil{
                newImage.image = image
            }
        })
    }
}