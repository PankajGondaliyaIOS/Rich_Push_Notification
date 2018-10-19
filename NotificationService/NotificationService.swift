//
//  NotificationService.swift
//  NotificationService
//
//  Created by Pankaj Gondaliya on 10/19/18.
//  Copyright © 2018 Pankaj Gondaliya. All rights reserved.
//

import UserNotifications
import SystemConfiguration
/* NotificationService extension will work only for Remote notification
 Notification Service Extensions, that let you change the content of the notification (attaching images, etc) do not work with local notifications.
 */
/* NotificationContentExtension will work for local and remote notification
 It allows you to present a ViewController in the expanded notification view, and works with both remote and local notification.
 */

class NotificationService: UNNotificationServiceExtension {
    
    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?
    
    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        if let bestAttemptContent = bestAttemptContent {
            // Modify the notification content here...
            //bestAttemptContent.badge = 10
            bestAttemptContent.title = "Hello!!"
            if bestAttemptContent.categoryIdentifier == NotificationCategory.InterestedNotInterested {
                print("Category identified")
            }
            
            if let apsData = bestAttemptContent.userInfo["aps"] as? [String: Any] {
                let urlString = apsData["attachment-url"] as? String
                let attachmentURL = URL(string: urlString!)
                // 5. Download the image and pass it to attachments if not nil
                downloadWithURL(url: attachmentURL!) { (attachment) in
                    bestAttemptContent.attachments = [attachment!]
                    contentHandler(bestAttemptContent)
                }
            }
        }
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }
    
}

// MARK: - Helper Functions
extension NotificationService {
    
    private func downloadWithURL(url: URL, completion: @escaping (UNNotificationAttachment?) -> Void) {
        let task = URLSession.shared.downloadTask(with: url) { (downloadedUrl, response, error) in
            //            guard let downloadedUrl = downloadedUrl else {
            //                completion(false)
            //                return
            //            }
            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            var url = URL(fileURLWithPath: path)
            url = url.appendingPathComponent("Image.png")
            try? FileManager.default.moveItem(at: downloadedUrl!, to: url)
            do {
                let attachment = try UNNotificationAttachment(identifier: "image", url: url, options: nil)
                self.bestAttemptContent?.attachments = [attachment]
                completion(attachment)
            }
            catch {
                completion(nil)
            }
        }
        task.resume()
    }
    
}

