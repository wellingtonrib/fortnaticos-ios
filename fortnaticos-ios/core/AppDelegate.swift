//
//  AppDelegate.swift
//  ios-base
//
//  Created by Wellington Ribeiro on 23/03/20.
//  Copyright © 2020 JWAR. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import FBSDKCoreKit
import GoogleSignIn
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    let gcmMessageIDKey = "gcm.message_id"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Override point for customization after application launch.
        self.setupGlobalAppearance()
        
        //IQKeyboardManager
        IQKeyboardManager.shared.enable = true
        
        //Facebook
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        //Google
        GIDSignIn.sharedInstance().clientID = AppClientIDs.GoogleClientID
        
        //Firebase
        FirebaseApp.configure()
        Messaging.messaging().delegate = self        
                
        //Handle links
        if ((launchOptions?[UIApplication.LaunchOptionsKey.userActivityDictionary]) != nil) {
            let activityDictionary = launchOptions?[UIApplication.LaunchOptionsKey.userActivityDictionary] as? [AnyHashable: Any] ?? [AnyHashable: Any]()
            let activity = activityDictionary["UIApplicationLaunchOptionsUserActivityKey"] as? NSUserActivity
            if activity != nil {
                if let url = activity?.webpageURL {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                        _ = FirebaseMessagingHandler.shared.handleLink(url: url, controller: self.topMostController())
                    })
                }
            }
        }
        
        //Register for remote notifications
        if #available(iOS 10.0, *) {
          // For iOS 10 display notification (sent via APNS)
          UNUserNotificationCenter.current().delegate = self

          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in })
        } else {
          let settings: UIUserNotificationSettings =
          UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          application.registerUserNotificationSettings(settings)
        }
        application.registerForRemoteNotifications()
        
//        for family in UIFont.familyNames.sorted() {
//            let names = UIFont.fontNames(forFamilyName: family)
//            print("Family: \(family) Font names: \(names)")
//        }
                
        return true
    }
    
    func setupGlobalAppearance() {
        //Customize fonts
        UITextField.appearance().substituteFontName = AppFonts.regularFont
        UILabel.appearance().substituteFontName = AppFonts.regularFont
        UILabel.appearance().substituteFontNameBold = AppFonts.boldFont
        UIButton.appearance().titleLabel?.font = UIFont.appRegularFontWith(size: 14)
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont.appRegularFontWith(size: 16)], for: .normal)
        UIBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont.appRegularFontWith(size: 8)], for: .normal)
        UIBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont.appRegularFontWith(size: 8)], for: .selected)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont.appRegularFontWith(size: 17)], for: .normal)
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.font: UIFont.appRegularFontWith(size: 24)]
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        let facebookLogin = ApplicationDelegate.shared.application(app, open: url, options: options)
        let googleLogin = GIDSignIn.sharedInstance().handle(url)
        
        return facebookLogin || googleLogin
    }
    
    func application(_ application: UIApplication,
                     open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
      return GIDSignIn.sharedInstance().handle(url)
    }
    
    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

}

extension AppDelegate {
    
    func topMostController() -> UIViewController {
        var topController: UIViewController = UIApplication.shared.keyWindow!.rootViewController!
        while (topController.presentedViewController != nil) {
            topController = topController.presentedViewController!
        }
        return topController
    }
    
}

extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // iOS10+, called when presenting notification in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
                
        // Print full message.
        print(userInfo)
        
        // Handle foreground notification
        let firebaseNotification = FirebaseMessagingHandler.shared.receiveNotification(userInfo: userInfo)
                
        // Change this to your preferred presentation option
        if let _ = firebaseNotification?.broadcast {
            completionHandler([])
        } else {
            completionHandler([.alert, .badge, .sound])
        }
    }
    
    // iOS10+, called when received response (default open, dismiss or custom action) for a notification
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = response.notification.request.content.userInfo
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        //TODO: Handle background notification
        _ = FirebaseMessagingHandler.shared.receiveNotification(userInfo: userInfo)
        
        // Change this to your preferred presentation option
        completionHandler()
    }
}

extension AppDelegate : MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
                
        FirebaseTokenManeger.shared.registerFCMToken(fcmToken: fcmToken)
        FirebaseTokenManeger.shared.sendRegistrationToServer()
    }
}

