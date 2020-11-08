//
//  UserDefaultsManager.swift
//  ios-base
//
//  Created by Wellington Ribeiro on 25/03/20.
//  Copyright © 2020 JWAR. All rights reserved.
//

import Foundation

class UserDefaultsManager {
    
    static let shared = UserDefaultsManager()
    
    let standard: UserDefaults = .standard
    
    private init() {}
        
}


