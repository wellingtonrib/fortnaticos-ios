//
//  FirebaseTokenManeger.swift
//  PPL
//
//  Created by Wellington Ribeiro on 14/03/2019.
//  Copyright © 2019 DimenutoLabs. All rights reserved.
//

import Foundation
import FirebaseInstanceID
import FirebaseMessaging
import Alamofire
import SwiftyJSON

class FirebaseTokenManeger {
    
    static let shared = FirebaseTokenManeger()
        
    private init() {}
    
    func verifyRegistrationToServer() {
        let defaults = UserDefaults.standard
        let fcmTokenHasSavedOnServerdOnServer = defaults.bool(forKey: "fcmTokenHasSavedOnServer")
        let fcmTokenSaved = defaults.string(forKey: "fcmToken")
                
        if !fcmTokenHasSavedOnServerdOnServer || Messaging.messaging().fcmToken != fcmTokenSaved {
            self.sendRegistrationToServer()
        }
    }
    
    func registerFCMToken(fcmToken: String) {
        let defaults = UserDefaults.standard
        defaults.set(fcmToken, forKey: "fcmToken")
        defaults.synchronize()
    }
    
    func sendRegistrationToServer() {        
        if let fcmToken = Messaging.messaging().fcmToken {
            ApiManager.shared.request(requestPath: "api/user/fcm-token",
                method: .post,
                parameters: [
                    "token": fcmToken,
                    "platform": "iOS"
                ]) { (result: Result<JSON,Error>) in
                
                let defaults = UserDefaults.standard
                    
                switch result {
                case .success( _):
                    defaults.set(true, forKey: "fcmTokenHasSavedOnServer")
                    defaults.set(fcmToken, forKey: "fcmToken")
                    defaults.synchronize()
                    Messaging.messaging().subscribe(toTopic: "geral") { error in
                        print("Subscribed to topic geral")
                    }
                case .failure( _):
                    defaults.set(false, forKey: "fcmTokenHasSavedOnServer")
                    defaults.synchronize()
                }
            }
        }
    }
}
