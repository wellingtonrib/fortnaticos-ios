//
//  UILabel.swift
//  ios-base
//
//  Created by Wellington Ribeiro on 23/03/20.
//  Copyright © 2020 JWAR. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    
    @objc var substituteFontName: String {
        get {
            return font.fontName
        }
        set {
            if font.fontName.range(of:"-Bold") == nil {
                font = UIFont(name: newValue, size: font.pointSize)
            }
        }
    }
    @objc var substituteFontNameBold: String {
        get {
            return font.fontName
        }
        set {
            if font.fontName.range(of:"-Bold") != nil {
                font = UIFont(name: newValue, size: font.pointSize)
            }
        }
    }
    
}
