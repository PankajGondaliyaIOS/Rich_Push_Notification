//
//  AppDelegate.swift
//  Rich_Pushnotification
//
//  Created by Pankaj Gondaliya on 10/19/18.
//  Copyright © 2018 Pankaj Gondaliya. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let notificationDelegate = NotificationHandler()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        configureNotification()
        return true
    }
    
    //MARK: Notification Methods
    func configureNotification() {
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in }
            center.delegate = notificationDelegate
            center.setNotificationCategories(Set([createIntrestedNotIntrestedCategory(), createMessageCategory()]))
        } else {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
        }
        UIApplication.shared.registerForRemoteNotifications()
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print("APNs device token: \(deviceTokenString)")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("APNs registration failed: \(error)")
    }
    
    //MARK: Notification Categories
    func createIntrestedNotIntrestedCategory()->UNNotificationCategory {
        let intrestedAction = UNNotificationAction(identifier: "UserChoiceIdentifierIntrested", title: "Intrested", options: [])
        let notIntrestedAction = UNNotificationAction(identifier: "UserChoiceIdentifierIntrested", title: "NotIntrested", options: [])
        let intrestedNotIntrestedCategory = UNNotificationCategory(identifier: NotificationCategory.InterestedNotInterested, actions: [intrestedAction, notIntrestedAction], intentIdentifiers: [], options: [])
        return intrestedNotIntrestedCategory
    }
    
    func createMessageCategory()-> UNNotificationCategory {
        let replyAction = UNTextInputNotificationAction(identifier: NotificationCategory.Message, title: "Reply", options: [], textInputButtonTitle: "Send", textInputPlaceholder: "Type your message")
        let categoryReplyAction = UNNotificationCategory(identifier: NotificationCategory.Message, actions: [replyAction], intentIdentifiers: [], options: [])
        return categoryReplyAction
    }
    
    /*
     func createAgreeDisagreeCategory()-> UNNotificationCategory {
     let agreedAction = UNNotificationAction(identifier: "UserChoiceIdentifierAgree", title: NSLocalizedString("Agree", comment: "Click to proceed"), options: UNNotificationActionOptions.foreground)
     let disAgreeAction = UNNotificationAction(identifier: "UserChoiceIdentifierDisAgree", title: NSLocalizedString("NotIntrested", comment: "Click to close"), options: UNNotificationActionOptions.foreground)
     let intrestedNotIntrestedCategory = UNNotificationCategory(identifier: "TypeAgreeDisagree", actions: [agreedAction, disAgreeAction], intentIdentifiers: [], options: [])
     return intrestedNotIntrestedCategory
     }
     */
    
}

