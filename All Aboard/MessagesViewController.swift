//
//  MessagesViewController.swift
//  FireChat-Swift
//
//  Created by Katherine Fang on 8/13/14.
//  Copyright (c) 2014 Firebase. All rights reserved.
//

import UIKit
import Foundation

/******************************************************************************************
*   This class is responsible for displaying and controller the Chat page
******************************************************************************************/
class MessagesViewController: JSQMessagesViewController {
    
    var user: FAuthData?
    
    var messages = [Message]()
    var avatars = Dictionary<String, UIImage>()
    var outgoingBubbleImageView = JSQMessagesBubbleImageFactory.outgoingMessageBubbleImageViewWithColor(UIColor.jsq_messageBubbleLightGrayColor())
    var incomingBubbleImageView = JSQMessagesBubbleImageFactory.incomingMessageBubbleImageViewWithColor(UIColor.jsq_messageBubbleGreenColor())
    var senderImageUrl: String!
    var batchMessages = true
//    var ref: Firebase!
    var chatRoomName = ""
    
    // *** STEP 1: STORE FIREBASE REFERENCES
    var messagesRef: Firebase!

    func setupFirebase() {
        // *** STEP 2: SETUP FIREBASE
        messagesRef = Firebase(url: "https://shining-torch-5663.firebaseio.com/chatRooms/\(chatRoomName)")

        // *** STEP 4: RECEIVE MESSAGES FROM FIREBASE
        messagesRef.observeEventType(FEventType.ChildAdded, withBlock: { (snapshot) in
            var text = snapshot.value["text"] as? String
            var sender = snapshot.value["sender"] as? String
            var imageUrl = snapshot.value["imageUrl"] as? String
            if text == nil {text = ""}
            if sender == nil {sender = ""}
            if imageUrl == nil {imageUrl = ""}
            let message = Message(text: text, sender: sender, imageUrl: imageUrl)
            
            self.messages.append(message)
            self.finishReceivingMessage()
        })
    }
    
    /******************************************************************************************
    *   Sends a message to the Firebase database
    ******************************************************************************************/
    func sendMessage(text: String!, sender: String!) {
        // *** STEP 3: ADD A MESSAGE TO FIREBASE
        messagesRef.childByAutoId().setValue([
            "text":text,
            "sender":sender,
            "imageUrl":"https://s3.amazonaws.com/allaboardimages/profilePictures/\(UserPreferences().getGUID())thumbnail.jpeg" // set the profile pic
        ])
    }
    
    /******************************************************************************************
    *
    ******************************************************************************************/
    func tempSendMessage(text: String!, sender: String!) {
        let message = Message(text: text, sender: sender, imageUrl: senderImageUrl)
        messages.append(message)
    }
    
    /******************************************************************************************
    *   Configures the avatar image that is displayed for each user in the chat
    ******************************************************************************************/
    func setupAvatarImage(name: String, imageUrl: String?, incoming: Bool) {
        if imageUrl == nil ||  count(imageUrl!) == 0 {
            setupAvatarColor(name, incoming: incoming)
            return
        }
        
        let diameter = incoming ? UInt(collectionView.collectionViewLayout.incomingAvatarViewSize.width) : UInt(collectionView.collectionViewLayout.outgoingAvatarViewSize.width)
        
        let url = NSURL(string: imageUrl!)
        let image = UIImage(data: NSData(contentsOfURL: url!)!)
        let avatarImage = JSQMessagesAvatarFactory.avatarWithImage(image, diameter: diameter)
        
        avatars[name] = avatarImage
    }
    
    /******************************************************************************************
    *   Configures the avatar color of the user
    ******************************************************************************************/
    func setupAvatarColor(name: String, incoming: Bool) {
        let diameter = incoming ? UInt(collectionView.collectionViewLayout.incomingAvatarViewSize.width) : UInt(collectionView.collectionViewLayout.outgoingAvatarViewSize.width)
        
        let rgbValue = name.hash
        let r = CGFloat(Float((rgbValue & 0xFF0000) >> 16)/255.0)
        let g = CGFloat(Float((rgbValue & 0xFF00) >> 8)/255.0)
        let b = CGFloat(Float(rgbValue & 0xFF)/255.0)
        let color = UIColor(red: r, green: g, blue: b, alpha: 0.5)
        
        let nameLength = count(name)
        let initials : String? = name.substringToIndex(advance(sender.startIndex, min(3, nameLength)))
        let userImage = JSQMessagesAvatarFactory.avatarWithUserInitials(initials, backgroundColor: color, textColor: UIColor.blackColor(), font: UIFont.systemFontOfSize(CGFloat(13)), diameter: diameter)
        
        avatars[name] = userImage
    }
    
    /******************************************************************************************
    *   Configures the firebase connection and how the messages should be displayed
    ******************************************************************************************/
    override func viewDidLoad() {
        super.viewDidLoad()
        inputToolbar.contentView.leftBarButtonItem = nil
        automaticallyScrollsToMostRecentMessage = true
        navigationController?.navigationBar.topItem?.title = "Logout"
        
        sender = (sender != nil) ? sender : "Anonymous"
        let profileImageUrl = user?.providerData["cachedUserProfile"]?["profile_image_url_https"] as? NSString
        if let urlString = profileImageUrl {
            setupAvatarImage(sender, imageUrl: urlString as String, incoming: false)
            senderImageUrl = urlString as String
        } else {
            setupAvatarColor(sender, incoming: false)
            senderImageUrl = ""
        }
        
        setupFirebase()
    }
    
    /******************************************************************************************
    *
    ******************************************************************************************/
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        collectionView.collectionViewLayout.springinessEnabled = true
    }
    
//    override func viewWillDisappear(animated: Bool) {
//        super.viewWillDisappear(animated)
//        
//        if ref != nil {
//            ref.unauth()
//        }
//    }
    
    // ACTIONS
    
    /******************************************************************************************
    *
    ******************************************************************************************/
    func receivedMessagePressed(sender: UIBarButtonItem) {
        // Simulate reciving message
        showTypingIndicator = !showTypingIndicator
        scrollToBottomAnimated(true)
    }
    
    /******************************************************************************************
    *   Plays a sound for sending a message and tells the message to be sent
    ******************************************************************************************/
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, date: NSDate!) {
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        let senderName = UserPreferences().getName()
        sendMessage(text, sender: senderName)
        
        finishSendingMessage()
    }
    
    /******************************************************************************************
    *
    ******************************************************************************************/
    override func didPressAccessoryButton(sender: UIButton!) {
        println("Camera pressed!")
    }
    
    /******************************************************************************************
    *   Returns the message data that will be presented later
    ******************************************************************************************/
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    /******************************************************************************************
    *   Displays the text bubble on the screen
    ******************************************************************************************/
    override func collectionView(collectionView: JSQMessagesCollectionView!, bubbleImageViewForItemAtIndexPath indexPath: NSIndexPath!) -> UIImageView! {
        let message = messages[indexPath.item]
        
        if message.sender() == sender {
            return UIImageView(image: outgoingBubbleImageView.image, highlightedImage: outgoingBubbleImageView.highlightedImage)
        }
        
        return UIImageView(image: incomingBubbleImageView.image, highlightedImage: incomingBubbleImageView.highlightedImage)
    }
    
    /******************************************************************************************
    *   Displays the avatar image on the screen
    ******************************************************************************************/
    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageViewForItemAtIndexPath indexPath: NSIndexPath!) -> UIImageView! {
        let message = messages[indexPath.item]
        if let avatar = avatars[message.sender()] {
            return UIImageView(image: avatar)
        } else {
            setupAvatarImage(message.sender(), imageUrl: message.imageUrl(), incoming: true)
            return UIImageView(image:avatars[message.sender()])
        }
    }
    
    /******************************************************************************************
    *
    ******************************************************************************************/
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    /******************************************************************************************
    *   Presents al the information to the screen
    ******************************************************************************************/
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as! JSQMessagesCollectionViewCell
        
        let message = messages[indexPath.item]
        if message.sender() == sender {
            cell.textView.textColor = UIColor.blackColor()
        } else {
            cell.textView.textColor = UIColor.whiteColor()
        }
        
        let attributes : [NSObject:AnyObject] = [NSForegroundColorAttributeName:cell.textView.textColor, NSUnderlineStyleAttributeName: 1]
        cell.textView.linkTextAttributes = attributes
        
        return cell
    }
    
    
    /******************************************************************************************
    *   Places the user name above the image bubble
    ******************************************************************************************/
    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        let message = messages[indexPath.item];
        
        // Sent by me, skip
        if message.sender() == sender {
            return nil;
        }
        
        // Same as previous sender, skip
        if indexPath.item > 0 {
            let previousMessage = messages[indexPath.item - 1];
            if previousMessage.sender() == message.sender() {
                return nil;
            }
        }
        
        return NSAttributedString(string:message.sender())
    }
    
    /******************************************************************************************
    *   Sets the height for the message bubbles
    ******************************************************************************************/
    override func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        let message = messages[indexPath.item]
        
        // Sent by me, skip
        if message.sender() == sender {
            return CGFloat(0.0);
        }
        
        // Same as previous sender, skip
        if indexPath.item > 0 {
            let previousMessage = messages[indexPath.item - 1];
            if previousMessage.sender() == message.sender() {
                return CGFloat(0.0);
            }
        }
        
        return kJSQMessagesCollectionViewCellLabelHeightDefault
    }
}
