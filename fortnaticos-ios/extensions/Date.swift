//
//  Date.swift
//  WTP
//
//  Created by Wellington Ribeiro on 28/05/19.
//  Copyright © 2019 Paulo Henrique. All rights reserved.
//

import Foundation

extension Date {
    
    func toStringFormat(dateFormat: String = "dd/MM/yy HH:mm") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.locale = Locale(identifier: "pt_BR")
        return DateFormatter().string(from: self)
    }
    
}
