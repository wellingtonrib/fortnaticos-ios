//
//  Bundle.swift
//  WTP
//
//  Created by Victor Hugo on 6/3/19.
//  Copyright © 2019 Paulo Henrique. All rights reserved.
//

import Foundation

public extension Bundle {
    
    var shortVersion: String {
        if let result = infoDictionary?["CFBundleShortVersionString"] as? String {
            return result
        } else {
            assert(false)
            return ""
        }
    }
    
    var buildVersion: String {
        if let result = infoDictionary?["CFBundleVersion"] as? String {
            return result
        } else {
            assert(false)
            return ""
        }
    }
    
    var fullVersion: String {
        return "\(shortVersion)(\(buildVersion))"
    }
    
    var target: String {
        if let result = infoDictionary?["CFBundleName"] as? String {
            return result
        } else {
            assert(false)
            return ""
        }
    }
    
}
