//
//  Double.swift
//  ios-base
//
//  Created by Wellington Ribeiro on 23/03/20.
//  Copyright © 2020 JWAR. All rights reserved.
//

import Foundation

extension Double {
    
    func toStringCurrency() -> String {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "pt_BR")
        formatter.numberStyle = .currency
        if let formattedAmount = formatter.string(from: self as NSNumber) {
            return formattedAmount
        }
        return ""
    }
    
}
