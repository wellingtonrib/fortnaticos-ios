//
//  FirebaseNotification.swift
//  PPL
//
//  Created by Wellington Ribeiro on 14/03/2019.
//  Copyright © 2019 DimenutoLabs. All rights reserved.
//

import Foundation

class FirebaseNotification: Codable {
    
    var id: Int = 0
    var title: String?
    var message: String?
    var action: String?
    var date : Date = Date()
    var read = false
    var link : String?
    var broadcast: String?
    
}
