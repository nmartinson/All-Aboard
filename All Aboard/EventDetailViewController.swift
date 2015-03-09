////
////  EventDetailViewController.swift
////  All Aboard
////
////  Created by Nick Martinson on 3/7/15.
////  Copyright (c) 2015 Nick Martinson. All rights reserved.
////
//
//import Foundation
//import UIKit
//import MobileCoreServices
//
//class EventDetailViewController: UIView
//{
//    @IBOutlet weak var profilePicture: UIImageView!
//    @IBOutlet weak var hostedByLabel: UILabel!
//    @IBOutlet weak var locationLabel: UILabel!
//    @IBOutlet weak var timeLabel: UILabel!
//    @IBOutlet weak var collectionView: UICollectionView!
//    let imagePicker = UIImagePickerController()
//
//    
//    
//    /******************************************************************************************
//    *   Open the camera roll
//    ******************************************************************************************/
//    @IBAction func upLoadButtonPressed(sender: UIButton)
//    {
//        var alertView = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
//        var cameraAction = UIAlertAction(title: "Camera", style: .Default)
//            {
//                action in
//                self.openCamera()
//        }
//        var galleryAction = UIAlertAction(title: "Gallery", style: .Default)
//            {
//                action in
//                self.openGallery()
//        }
//        var cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
//        
//        alertView.addAction(cameraAction)
//        alertView.addAction(galleryAction)
//        alertView.addAction(cancelAction)
//        
////        presentViewController(alertView, animated: true, completion: nil)
//    }
//    
//    /******************************************************************************************
//    *   Open camera
//    ******************************************************************************************/
//    func openCamera()
//    {
//        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
//        {
//            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
//            imagePicker.mediaTypes = [kUTTypeImage as NSString]
//            imagePicker.allowsEditing = false
//            self.presentViewController(imagePicker, animated: true, completion: nil)
//        }
//    }
//    
//    /******************************************************************************************
//    *   Open camera roll
//    ******************************************************************************************/
//    func openGallery()
//    {
//        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum)
//        {
//            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
//            imagePicker.mediaTypes = [kUTTypeImage as NSString]
//            imagePicker.allowsEditing = false
//            self.presentViewController(imagePicker, animated: true, completion: nil)
//        }
//    }
//    
//    /******************************************************************************************
//    *   Save the picked image
//    ******************************************************************************************/
//    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!)
//    {
//        photoCollection.append(image)
//        //        BluemixCommunication().sendImage(image)
//        self.dismissViewControllerAnimated(true, completion: nil)
//        photoGalleryCollectionView.reloadData()
//    }
//    
//    /******************************************************************************************
//    *   When a cell is about to be displayed, the image gets set
//    ******************************************************************************************/
//    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
//    {
//        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("photoCell", forIndexPath: indexPath) as PhotoGalleryCollectionViewCell
//        cell.image.image = photoCollection[indexPath.item]
//        
//        return cell
//    }
//
//    /******************************************************************************************
//    *   Open the image to full screen with animation when selected
//    ******************************************************************************************/
//    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
//    {
//        let thumbnail = collectionView.cellForItemAtIndexPath(indexPath)?.contentView.subviews.last as UIImageView
//        imageView = UIImageView(image: photoCollection[indexPath.row])
//        imageView!.contentMode = thumbnail.contentMode
//        imageScroll.contentSize = imageView!.frame.size
//        
//        let scaleWidth = imageScroll.frame.size.width / imageScroll.contentSize.width
//        let scaleHeight = imageScroll.frame.size.height / imageScroll.contentSize.height
//        let minScale = min(scaleHeight, scaleWidth)
//        imageScroll.minimumZoomScale = minScale
//        imageScroll.maximumZoomScale = 1
//        imageScroll.zoomScale = minScale
//        imageScroll.frame = thumbnail.frame
//        imageScroll.addSubview(imageView!)
//        self.view.addSubview(self.blackView)
//        
//        // hide the status bar
//        self.statusBarHidden = true
//        self.prefersStatusBarHidden()
//        
//        // open the image
//        UIView.transitionWithView(self.view, duration: 1,
//            options: UIViewAnimationOptions.AllowAnimatedContent,
//            animations: {
//                self.navigationController?.navigationBar.alpha = 0 // hide navbar
//                self.blackView.alpha = 1    // show black background
//                self.view.addSubview(self.imageScroll)
//                self.imageScroll.frame = self.view.frame
//                self.imageView!.center = self.imageScroll.center
//                self.imageScroll.contentSize = self.imageView!.frame.size},
//            completion: nil)
//    }
//
//    
//}