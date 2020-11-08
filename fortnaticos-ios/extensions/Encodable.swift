//
//  Encodable.swift
//  ios-base
//
//  Created by Wellington Ribeiro on 26/03/20.
//  Copyright © 2020 JWAR. All rights reserved.
//

import Foundation

extension Encodable {
    
    var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
    
}

