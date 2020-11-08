//
//  UITextField.swift
//  ios-base
//
//  Created by Wellington Ribeiro on 23/03/20.
//  Copyright © 2020 JWAR. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    
    var substituteFontName : String {
        get {
            return font?.fontName ?? AppFonts.regularFont
        }
        set {
            if let font = self.font {
                self.font = UIFont(name: newValue, size: font.pointSize)
            } else {
                self.font = UIFont.appRegularFontWith(size: 16)
            }
        }
    }
    
}
