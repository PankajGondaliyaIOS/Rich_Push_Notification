//
//  ViewController.swift
//  Rich_Pushnotification
//
//  Created by Pankaj Gondaliya on 10/19/18.
//  Copyright © 2018 Pankaj Gondaliya. All rights reserved.
//

import UIKit

import UserNotifications

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: Action Methods
    
    //Local notification with Image
    @IBAction func localNotificationWithImage() {
        let url = Bundle.main.url(forResource: "smallImage", withExtension: "jpg")
        let attachment = try! UNNotificationAttachment(identifier: "image", url: url!, options: [:])
        generateNotification(attachment: attachment, requestIdentifier: "IMAGE", notificationCategory: "IMAGE")
    }
    
    //Local notification with Video
    @IBAction func localNotificationWithVideo() {
        let url = Bundle.main.url(forResource: "small_video", withExtension: "mp4")
        let attachment = try! UNNotificationAttachment(identifier: "Movie", url: url!, options: [:])
        //requeseIdentifier can be used to update the notification
        generateNotification(attachment: attachment, requestIdentifier: "VIDEO", notificationCategory: "")
    }
    
    //Local notification with Message
    @IBAction func inputTextFieldType() {
        let url = Bundle.main.url(forResource: "smallImage", withExtension: "jpg")
        let attachment = try! UNNotificationAttachment(identifier: "image", url: url!, options: [:])
        generateNotification(attachment: attachment, requestIdentifier: "IMAGE", notificationCategory: NotificationCategory.Message)
    }
    
    //Local notification with Custom Buttons
    @IBAction func localNotificationWithCustomButtons() {
        let url = Bundle.main.url(forResource: "smallImage", withExtension: "jpg")
        let attachment = try! UNNotificationAttachment(identifier: "image", url: url!, options: [:])
        attachment.url.stopAccessingSecurityScopedResource()
        
        generateNotification(attachment: attachment, requestIdentifier: "IMAGE", notificationCategory: NotificationCategory.InterestedNotInterested)
    }
    
    //Remove Notification: Here, we are removing notification with identifier "IMAGE"
    @IBAction func removeImageNotification() {
        UNUserNotificationCenter.current().getDeliveredNotifications(completionHandler: { (notifications) in
            print(notifications)
            for notification in notifications as [UNNotification]{
                print(notification.request.identifier)
                if(notification.request.identifier == "IMAGE") {
                    UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [notification.request.identifier])
                    //                    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [notification.request.identifier])
                }
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

//MARK: Generate Local Notification
extension ViewController {
    func generateNotification(attachment: UNNotificationAttachment?, requestIdentifier: String, notificationCategory: String) {
        let content = UNMutableNotificationContent()
        content.title = "Hello!!"
        content.body = "Ready for the event!"
        content.sound = UNNotificationSound.default()
        // Set category
        content.categoryIdentifier = notificationCategory
        
        if(attachment != nil) {
            content.attachments = [attachment!]
        }
        // Deliver the notification in five seconds.
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        let request = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: trigger)
        
        // Schedule the notification.
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error) in
            print(error ?? "Initiated successfully")
        }
        print("should have been added")
    }
}

//MARK: Useful links
extension ViewController {
    //“mutable-content”: 1 == There is a new parameter “mutable-content” in “aps”. This signifies that the OS should initiate the service extension of the app to perform some extra processing.
    
    //1. Attachment Types:
    //https://developer.apple.com/documentation/usernotifications/unnotificationattachment
    //2. Text Input
    //https://developer.apple.com/documentation/usernotifications/untextinputnotificationaction
    //3. Actionable type
    //https://developer.apple.com/documentation/usernotifications/declaring_your_actionable_notification_types
    //4. Other
    //https://developer.apple.com/documentation/usernotifications/unnotificationaction
    
}


