//
//  UISegmentedControl.swift
//  Aboa
//
//  Created by Wellington Ribeiro on 10/12/19.
//  Copyright © 2019 Victor Hugo. All rights reserved.
//

import Foundation
import UIKit

extension UISegmentedControl {

    func fallBackToPreIOS13Layout(using tintColor: UIColor, backgroundImageColor: UIColor = .clear, titleColorSelected: UIColor = .white) {
        if #available(iOS 13, *) {
            let backGroundImage = UIImage(color: backgroundImageColor, size: CGSize(width: 1, height: 32))
            let dividerImage = UIImage(color: tintColor, size: CGSize(width: 1, height: 32))

            setBackgroundImage(backGroundImage, for: .normal, barMetrics: .default)
            setBackgroundImage(dividerImage, for: .selected, barMetrics: .default)

            setDividerImage(dividerImage,
                            forLeftSegmentState: .normal,
                            rightSegmentState: .normal, barMetrics: .default)

            layer.borderWidth = 1
            layer.borderColor = tintColor.cgColor

            setTitleTextAttributes([.foregroundColor: tintColor], for: .normal)
            setTitleTextAttributes([.foregroundColor: titleColorSelected], for: .selected)
        } else {
            self.tintColor = tintColor
        }
  }
}
