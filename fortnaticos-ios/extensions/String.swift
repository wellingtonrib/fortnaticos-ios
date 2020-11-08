//
//  String.swift
//  Papa Légua
//
//  Created by Luiz Soares on 01/02/19.
//  Copyright © 2019 Luiz Soares. All rights reserved.
//

import Foundation
import Alamofire

extension String {

    func onlyNumbers() -> String{
        return self.components(separatedBy:CharacterSet.decimalDigits.inverted)
            .joined(separator: "")
    }
    
    func regexReplace(pattern : String, replace : String) -> String {
        let regex = try! NSRegularExpression(pattern: pattern, options: [])
        return regex.stringByReplacingMatches(in: self, options: [], range: NSMakeRange(0, self.count), withTemplate: replace)
    }
    
    func toDoubleCurrency() -> Double {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "pt_BR")
        formatter.numberStyle = .currency
        if let formattedAmount = formatter.number(from: self) {
            return Double(truncating: formattedAmount)
        }
        return 0.0
    }
    
    func toDate(dateFormat: String = "dd/MM/yyyy HH:mm") -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.locale = Locale(identifier: "pt_BR")
        return formatter.date(from: self)
    }
    
    func urlEncoded() -> String {
        return self.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
    }
    
    func matches(for regex: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: self,
                                        range: NSRange(self.startIndex..., in: self))
            return results.map {
                String(self[Range($0.range, in: self)!])
            }
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
    
}

extension NSMutableAttributedString {
    
    func setColor(color: UIColor, forText stringValue: String) {
        let range: NSRange = self.mutableString.range(of: stringValue, options: .caseInsensitive)
        self.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
    }
    
    func setBold(forText stringValue: String, font: UIFont) {
        let range: NSRange = self.mutableString.range(of: stringValue, options: .caseInsensitive)
        let boldFontAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: font.pointSize)]
        self.addAttributes(boldFontAttribute, range: range)
    }
    
}


