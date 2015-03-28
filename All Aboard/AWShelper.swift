//
//  AWShelper.swift
//  All Aboard
//
//  Created by Nick Martinson on 3/24/15.
//  Copyright (c) 2015 Nick Martinson. All rights reserved.
//

import Foundation
import CoreGraphics
import ImageIO
import MobileCoreServices

class AWShelper
{
    /******************************************************************************************
    *   Downloads a single image from AWS
    ******************************************************************************************/
    func downloadImageFromS3(folder: String, file:String?, photoNumber: Int?, completion: (image: UIImage?) -> Void)
    {
        // DOWNLOADS AN IMAGE
        let transferManager = AWSS3TransferManager.defaultS3TransferManager()
        var downloadFilePath = ""
        //creates a new path in the tmp folder to store the image. need to clear this folder later
        if folder == "profilePictures"
        {
            downloadFilePath = NSTemporaryDirectory().stringByAppendingPathComponent("downloaded-myImage\(file).jpg")
        }
        else
        {
            downloadFilePath = NSTemporaryDirectory().stringByAppendingPathComponent("downloaded-myImage\(photoNumber!).jpg")
        }

        let downloadingURL = NSURL(fileURLWithPath: downloadFilePath)
        let downloadRequest = AWSS3TransferManagerDownloadRequest()
    
        if file != nil
        {
            downloadRequest.key = "\(folder)/\(file!).jpeg"
        }
        else
        {
            downloadRequest.key = "\(folder)/image\(photoNumber!).jpeg"
        }
    
        downloadRequest.bucket = "allaboardimages"
        downloadRequest.downloadingFileURL = downloadingURL
        transferManager.download(downloadRequest).continueWithExecutor(BFExecutor.mainThreadExecutor(), withBlock: { (task: BFTask!) -> AnyObject! in

            if (task.error != nil)
            {
                println("Error \(task.error)")
                completion(image: UIImage(named: "defaultProfilePicture"))
            }
            if (task.result != nil)
            {
                let downloadOutput = task.result as AWSS3TransferManagerDownloadOutput
                let image = UIImage(contentsOfFile: downloadFilePath)!
                completion(image: image)
            }
            return nil
        })
    }
    
    
    /******************************************************************************************
    *   Downloads a single thumbnail image from AWS
    ******************************************************************************************/
    func downloadThumbnailImageFromS3(folder: String, file:String?, photoNumber: Int?, completion: (image: UIImage?) -> Void)
    {
        // DOWNLOADS AN IMAGE
        let transferManager = AWSS3TransferManager.defaultS3TransferManager()
        var downloadFilePath = ""
        //creates a new path in the tmp folder to store the image. need to clear this folder later
        if folder == "profilePictures"
        {
            downloadFilePath = NSTemporaryDirectory().stringByAppendingPathComponent("downloaded-myImage\(file).jpg")
        }
        else
        {
            downloadFilePath = NSTemporaryDirectory().stringByAppendingPathComponent("downloaded-myImage\(photoNumber!).jpg")
        }
        
        
        let downloadingURL = NSURL(fileURLWithPath: downloadFilePath)
        let downloadRequest = AWSS3TransferManagerDownloadRequest()
        
        if file != nil
        {
            downloadRequest.key = "\(folder)/\(file!)thumbnail.jpeg"
        }
        else
        {
            downloadRequest.key = "\(folder)/image\(photoNumber!)thumbnail.jpeg"
        }
        
        downloadRequest.bucket = "allaboardimages"
        downloadRequest.downloadingFileURL = downloadingURL
        transferManager.download(downloadRequest).continueWithExecutor(BFExecutor.mainThreadExecutor(), withBlock: { (task: BFTask!) -> AnyObject! in
            
            if (task.error != nil)
            {
                println("Error \(task.error)")
                completion(image: UIImage(named: "defaultProfilePicture"))
            }
            if (task.result != nil)
            {
                let downloadOutput = task.result as AWSS3TransferManagerDownloadOutput
                let image = UIImage(contentsOfFile: downloadFilePath)!
                completion(image: image)
            }
            return nil
        })
    }
    
    func compressImageToThumbnail(image: UIImage) -> NSURL
    {
        var path:NSString = NSTemporaryDirectory().stringByAppendingPathComponent("thumbnail.jpeg")
        var imageData = UIImageJPEGRepresentation(image, 1) // minimum compression
        imageData.writeToFile(path, atomically: true)
        
        // once the image is saved we can use the path to create a local fileurl
        var url:NSURL = NSURL(fileURLWithPath: path)!
        let src = CGImageSourceCreateWithURL(url, nil)
        
        // thumbnail options
        let thumbOptions:[String:AnyObject] = [kCGImageSourceShouldAllowFloat: kCFBooleanTrue,
            kCGImageSourceCreateThumbnailWithTransform: kCFBooleanTrue,
            kCGImageSourceCreateThumbnailFromImageAlways: kCFBooleanTrue,
            kCGImageSourceThumbnailMaxPixelSize: Int(200)]
        let thumbnail = CGImageSourceCreateThumbnailAtIndex(src, 0, thumbOptions)
        
        let destination = CGImageDestinationCreateWithURL(url, kUTTypeJPEG, 1, nil)
        CGImageDestinationAddImage(destination, thumbnail, nil)
        if !CGImageDestinationFinalize(destination)
        {
            println("failed")
        }
        return url
    }
    

    
    /******************************************************************************************
    *   Compresses the image to a max width or height of 640px
    *   return: NSURL which is a file path to where the image to send is stored
    ******************************************************************************************/
    func compressImage(image: UIImage) -> NSURL
    {
        var path:NSString = NSTemporaryDirectory().stringByAppendingPathComponent("image.jpeg")
        //        var imageData:NSData = UIImagePNGRepresentation(image)
        var imageData = UIImageJPEGRepresentation(image, 0.5)
        imageData.writeToFile(path, atomically: true)
        
        // once the image is saved we can use the path to create a local fileurl
        var url:NSURL = NSURL(fileURLWithPath: path)!
        let src = CGImageSourceCreateWithURL(url, nil)
        
        // thumbnail options
        let thumbOptions:[String:AnyObject] = [kCGImageSourceShouldAllowFloat: kCFBooleanTrue,
            kCGImageSourceCreateThumbnailWithTransform: kCFBooleanTrue,
            kCGImageSourceCreateThumbnailFromImageAlways: kCFBooleanTrue,
            kCGImageSourceThumbnailMaxPixelSize: Int(640)]
        let thumbnail = CGImageSourceCreateThumbnailAtIndex(src, 0, thumbOptions)
        
        let destination = CGImageDestinationCreateWithURL(url, kUTTypeJPEG, 1, nil)
        CGImageDestinationAddImage(destination, thumbnail, nil)
        if !CGImageDestinationFinalize(destination)
        {
            println("failed")
        }
        return url
    }
    
    /******************************************************************************************
    *   Sends the image to AWS
    ******************************************************************************************/
    func uploadToS3(url: NSURL, folder: String, file: String?, photoNumber: Int?)
    {
        // next we set up the S3 upload request manager
        let uploadRequest = AWSS3TransferManagerUploadRequest()
        // set the bucket
        uploadRequest.bucket = "allaboardimages"
        // I want this image to be public to anyone to view it so I'm setting it to Public Read
        uploadRequest.ACL = AWSS3ObjectCannedACL.PublicRead
        // set the image's name that will be used on the s3 server. I am also creating a folder to place the image in
        
        if file != nil
        {
            uploadRequest.key = "\(folder)/\(file!).jpeg"
        }
        else
        {
            uploadRequest.key = "\(folder)/image\(photoNumber!).jpeg"
        }
        // set the content type
        uploadRequest.contentType = "image/jpeg"

        // and finally set the body to the local file path
        uploadRequest.body = url

        uploadRequest.ACL = AWSS3ObjectCannedACL.PublicRead
        
        // we will track progress through an AWSNetworkingUploadProgressBlock
        uploadRequest?.uploadProgress = {[unowned self](bytesSent:Int64, totalBytesSent:Int64, totalBytesExpectedToSend:Int64) in
        
            dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                let amountUploaded = totalBytesSent
                let filesize = totalBytesExpectedToSend;
                println("upload %\(Float(amountUploaded) / Float(filesize) )")
            })
        }
        
        // now the upload request is set up we can creat the transfermanger, the credentials are already set up in the app delegate
        var transferManager:AWSS3TransferManager = AWSS3TransferManager.defaultS3TransferManager()
        // start the upload
        transferManager.upload(uploadRequest!).continueWithExecutor(BFExecutor.mainThreadExecutor(), withBlock:{ [unowned self]
            task -> AnyObject in
            
            // once the uploadmanager finishes check if there were any errors
            if(task.error != nil)
            {
                NSLog("%@", task.error)
            }
            
            return "all done"
        })
    }
    
    /******************************************************************************************
    *   Sends the image to AWS
    ******************************************************************************************/
    func uploadThumbnailToS3(url: NSURL, folder: String, file: String?, photoNumber: Int?)
    {
        // next we set up the S3 upload request manager
        let uploadRequest = AWSS3TransferManagerUploadRequest()
        // set the bucket
        uploadRequest.bucket = "allaboardimages"
        // I want this image to be public to anyone to view it so I'm setting it to Public Read
        uploadRequest.ACL = AWSS3ObjectCannedACL.PublicRead
        // set the image's name that will be used on the s3 server. I am also creating a folder to place the image in
        
        if file != nil
        {
            uploadRequest.key = "\(folder)/\(file!)thumbnail.jpeg"
        }
        else
        {
            uploadRequest.key = "\(folder)/image\(photoNumber!)thumbnail.jpeg"
        }
        // set the content type
        uploadRequest.contentType = "image/jpeg"
        
        // and finally set the body to the local file path
        uploadRequest.body = url
        
        uploadRequest.ACL = AWSS3ObjectCannedACL.PublicRead
        
        // we will track progress through an AWSNetworkingUploadProgressBlock
        uploadRequest?.uploadProgress = {[unowned self](bytesSent:Int64, totalBytesSent:Int64, totalBytesExpectedToSend:Int64) in
            
            dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                let amountUploaded = totalBytesSent
                let filesize = totalBytesExpectedToSend;
                println("upload %\(Float(amountUploaded) / Float(filesize) )")
            })
        }
        
        // now the upload request is set up we can creat the transfermanger, the credentials are already set up in the app delegate
        var transferManager:AWSS3TransferManager = AWSS3TransferManager.defaultS3TransferManager()
        // start the upload
        transferManager.upload(uploadRequest!).continueWithExecutor(BFExecutor.mainThreadExecutor(), withBlock:{ [unowned self]
            task -> AnyObject in
            
            // once the uploadmanager finishes check if there were any errors
            if(task.error != nil)
            {
                NSLog("%@", task.error)
            }
            
            return "all done"
        })
    }
    
    
    func numberOfFilesInFolder(folder: String, completion: (count:Int) -> Void)
    {
        AWSS3Object()
        
        let request = AWSS3ListObjectsRequest()
        request.bucket = "allaboardimages"
        request.prefix = folder + "/"
        request.delimiter = "/"

        AWSS3ListObjectsOutput()
        AWSS3.defaultS3().listObjects(request).continueWithExecutor(BFExecutor.mainThreadExecutor(), withBlock: { (response) -> AnyObject! in
            if (response.error != nil)
            {
                println("error \(response.error)")
            }
            else
            {
                if let count = (response.result as AWSS3ListObjectsOutput).contents?.count
                {
                    let number = count/2
                    completion(count: number)
                }
                else
                {
                    completion(count: 0)
                }

            }
            return nil
        })
    }
    
    
    
}