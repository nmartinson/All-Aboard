//
//  AWShelper.swift
//  All Aboard
//
//  Created by Nick Martinson on 3/24/15.
//  Copyright (c) 2015 Nick Martinson. All rights reserved.
//

import Foundation

class AWShelper
{
    func downloadFromS3(view: UIViewController)
    {
    // DOWNLOADS AN IMAGE
            let transferManager = AWSS3TransferManager.defaultS3TransferManager()
            let downloadFilePath = NSTemporaryDirectory().stringByAppendingPathComponent("downloaded-myImage.jpg")
            let downloadingURL = NSURL(fileURLWithPath: downloadFilePath)
            let downloadRequest = AWSS3TransferManagerDownloadRequest()
            downloadRequest.bucket = "allaboardimages"
            downloadRequest.key = "drinks.jpg"
            downloadRequest.downloadingFileURL = downloadingURL
            transferManager.download(downloadRequest).continueWithExecutor(BFExecutor.mainThreadExecutor(), withBlock: { (task: BFTask!) -> AnyObject! in
    
                if (task.error != nil)
                {
                    println("Error \(task.error)")
                }
                if (task.result != nil)
                {
                    let downloadOutput = task.result as AWSS3TransferManagerDownloadOutput
                    let image = UIImage(contentsOfFile: downloadFilePath)!
                    let imageView = UIImageView(image: image)
                    view.view.addSubview(imageView)
                    println(image)
                }
                println("block")
                return nil
            })
    }
    
    func uploadToS3(image: UIImage)
    {

        // get the image from a UIImageView that is displaying the selected Image
        println("upload")
        // create a local image that we can use to upload to s3
        var path:NSString = NSTemporaryDirectory().stringByAppendingPathComponent("image.jpeg")
//        var imageData:NSData = UIImagePNGRepresentation(image)
        var imageData = UIImageJPEGRepresentation(image, 0.5)
        imageData.writeToFile(path, atomically: true)
        
        // once the image is saved we can use the path to create a local fileurl
        var url:NSURL = NSURL(fileURLWithPath: path)!
        
        // next we set up the S3 upload request manager
        let uploadRequest = AWSS3TransferManagerUploadRequest()
        // set the bucket
        uploadRequest.bucket = "allaboardimages"
        // I want this image to be public to anyone to view it so I'm setting it to Public Read
        uploadRequest.ACL = AWSS3ObjectCannedACL.PublicRead
        // set the image's name that will be used on the s3 server. I am also creating a folder to place the image in
        uploadRequest.key = "image.jpeg"
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
            if(task.error != nil){
                NSLog("%@", task.error);
            }else{ // if there aren't any then the image is uploaded!
                // this is the url of the image we just uploaded
                NSLog("https://s3.amazonaws.com/s3-demo-swift/foldername/image.png");
            }
            
//            self.removeLoadingView()
            return "all done";
        })
    }
    
    
    
    
    
    
    
    
}