//
//  NotificationHandler.swift
//  Rich_Pushnotification
//
//  Created by Pankaj Gondaliya on 10/19/18.
//  Copyright © 2018 Pankaj Gondaliya. All rights reserved.
//

import Foundation
import UserNotifications
import UserNotificationsUI

class NotificationHandler: NSObject , UNUserNotificationCenterDelegate {
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert,.sound])
    }
    
    //This method will be used to detect user taps. It will detect tap for UNNotificationActions and user tapping on notification.
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        print(response)
        switch response.actionIdentifier {
        case UNNotificationDefaultActionIdentifier:
            print("Open Action")
            break
        case "UserChoiceIdentifierIntrested":
            intrested()
            break
        case "UserChoiceIdentifierNotIntrested":
            NotIntrested()
            break
        case "UserChoiceIdentifierAgree":
            agree()
            break
        case "UserChoiceIdentifierDisAgree":
            disAgree()
            break
        case NotificationCategory.Message:
            messageReceived()
            break
        default:
            print("default")
        }
        completionHandler()
    }
    
    //MARK: Notification Custom Buttons Clicked
    func intrested() {
        print("Intrested action clicked")
    }
    
    func NotIntrested() {
        print("NotIntrested action clicked")
    }
    
    func agree() {
        print("Agree action clicked")
    }
    
    func disAgree() {
        print("DisAgree action clicked")
    }
    
    func messageReceived() {
        print("Message input by user")
    }
    
}
