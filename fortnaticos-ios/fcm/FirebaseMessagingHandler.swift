//
//  FirebaseMessagingHandler.swift
//  PPL
//
//  Created by Wellington Ribeiro on 14/03/2019.
//  Copyright © 2019 DimenutoLabs. All rights reserved.
//

import Foundation
import Foundation
import UIKit
import Alamofire

class FirebaseMessagingHandler {
    
    static let shared = FirebaseMessagingHandler()
        
    private init() {}
    
    func firebaseNotificationFromUserInfo(userInfo: [AnyHashable:Any]) -> FirebaseNotification? {
        
        guard let notificationData = (try? JSONSerialization.data(withJSONObject: userInfo, options: [])) else { return nil }
        
        return try? JSONDecoder().decode(FirebaseNotification.self, from: notificationData)
    }
    
    func receiveNotification(userInfo : [AnyHashable:Any]) -> FirebaseNotification? {
                                        
        if let notification = self.firebaseNotificationFromUserInfo(userInfo: userInfo) {
            
            if let broadcast = notification.broadcast {
                NotificationCenter.default.post(name: Notification.Name(rawValue: broadcast), object: self, userInfo: userInfo)
                return notification
            }
            
            notification.date = Date()
            notification.read = false
            
            self.save(notification: notification)
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: "notification_received"), object: self, userInfo: userInfo)
            
            if let link = notification.link {
                NotificationCenter.default.post(name: Notification.Name(rawValue: link), object: notification, userInfo: userInfo)
            }
            
            return notification
        }
        
        return nil
    }
    
    func save(notification: FirebaseNotification) {
        var notifications = load()
        if notification.id == 0 {
            notification.id = notifications.count + 1
        }
        notifications.append(notification)
        self.update(notifications: notifications)
    }
    
    func executeNotification(controller: UIViewController, notification: FirebaseNotification, popPreviousControllers: Bool = true) -> Bool {
        var executed = false
        
        if let link = notification.link {
        
            if let url = URL(string: link) {
                executed = self.handleLink(url: url, controller: controller)
            }
        }
        read(n: notification)
        return executed
    }
    
    func handleLink(url: URL, controller: UIViewController) -> Bool {
        var paths = url.pathComponents.filter({ $0 != "/"})
        
        let route = paths.removeFirst()
    
        return false
    }
    
    func readAll(read: Bool = true) {
        let notifications = load().map { (notification) -> FirebaseNotification in
            notification.read = read
            return notification
        }
        self.update(notifications: notifications)
    }
    
    func readAllFromLink(link: String) {
        let notifications = load().map { (notification) -> FirebaseNotification in
            if notification.link == link {
                notification.read = true
            }
            return notification
        }
        self.update(notifications: notifications)
    }
    
    func readFromNotification(n: Notification) {
        if let userInfo = n.userInfo, let firebaseNotification = self.firebaseNotificationFromUserInfo(userInfo: userInfo) {
            read(n: firebaseNotification)
        }
    }
    
    func read(n: FirebaseNotification) {
        let notifications = load().map { (notification) -> FirebaseNotification in
            if (notification.id == n.id) {
                notification.read = true
            }
            return notification
        }
        self.update(notifications: notifications)
    }
    
    func updateBadgeWithoutSave() {
        let notifications = load()
        let badgeCount = notifications.filter({ $0.read == false }).count
        UIApplication.shared.applicationIconBadgeNumber = badgeCount+1
    }
    
    func updateBadge() {
        let notifications = load()
        let badgeCount = notifications.filter({ $0.read == false }).count
        UIApplication.shared.applicationIconBadgeNumber = badgeCount
    }
    
    func load() -> [FirebaseNotification] {
        guard let encodedData = UserDefaults.standard.array(forKey: "notifications") as? [Data] else { return [] }

        let notifications = encodedData.map { try! JSONDecoder().decode(FirebaseNotification.self, from: $0) }
        
        return notifications.sorted(by: { (n1, n2) -> Bool in
            return n1.date.compare(n2.date) == .orderedDescending
        })
    }
    
    func update(notifications: [FirebaseNotification]) {
        let data = notifications.map { try? JSONEncoder().encode($0) }
        UserDefaults.standard.set(data, forKey: "notifications")
        UserDefaults.standard.synchronize()
        self.updateBadge()
    }
    
}
