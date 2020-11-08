//
//  UserDefaults.swift
//  ios-base
//
//  Created by Wellington Ribeiro on 25/03/20.
//  Copyright © 2020 JWAR. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    func set<Element: Encodable>(value: Element, forKey key: String) {
        let data = try? JSONEncoder().encode(value)
        self.setValue(data, forKey: key)
    }
    
    func decodable<Element: Decodable>(forKey key: String) -> Element? {
        guard let data = self.data(forKey: key) else { return nil }
        let element = try? JSONDecoder().decode(Element.self, from: data)
        return element
    }
}
