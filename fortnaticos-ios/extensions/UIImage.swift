//
//  UIImage.swift
//  Aboa
//
//  Created by Wellington Ribeiro on 10/12/19.
//  Copyright © 2019 Victor Hugo. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {

    convenience init?(color: UIColor, size: CGSize) {
        UIGraphicsBeginImageContextWithOptions(size, false, 1)
        color.set()
        guard let ctx = UIGraphicsGetCurrentContext() else { return nil }
        ctx.fill(CGRect(origin: .zero, size: size))
        guard
            let image = UIGraphicsGetImageFromCurrentImageContext(),
            let imagePNGData = image.pngData()
            else { return nil }
        UIGraphicsEndImageContext()

        self.init(data: imagePNGData)
   }
    
    enum WaterMarkCorner
    {
        case TopLeft
        case TopRight
        case BottomLeft
        case BottomRight
    }

    func waterMarkedImage(text:String, corner:WaterMarkCorner = .BottomLeft, margin:CGPoint = CGPoint(x: 40, y: 40), color:UIColor = UIColor.white, font:UIFont = UIFont(name: AppFonts.boldFont, size: 30) ?? UIFont.systemFont(ofSize: 30), background:UIColor = AppColor.primaryColorDark) -> UIImage?
    {
        let shadow = NSShadow()
        shadow.shadowBlurRadius = 3
        shadow.shadowOffset = CGSize(width: 2, height: 2)
        shadow.shadowColor = UIColor.black
        
        let attributes = [
            NSAttributedString.Key.foregroundColor: color,
            NSAttributedString.Key.font:font,
            NSAttributedString.Key.shadow: shadow
        ]
        let textSize = NSString(string: text).size(withAttributes: attributes)
        var frame = CGRect(x: 0, y: 0, width: textSize.width, height: textSize.height)

        let imageSize = self.size
        switch corner
        {
            case .TopLeft:
                frame.origin = margin
            case .TopRight:
                frame.origin = CGPoint(x: imageSize.width - textSize.width - margin.x, y: margin.y)
            case .BottomLeft:
                frame.origin = CGPoint(x: margin.x, y: imageSize.height - textSize.height - margin.y)
            case .BottomRight:
                frame.origin = CGPoint(x: imageSize.width - textSize.width - margin.x, y: imageSize.height - textSize.height - margin.y)
        }

        // Start creating the image with water mark
        UIGraphicsBeginImageContext(imageSize)
        self.draw(in: CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height))
        NSString(string: text).draw(in: frame, withAttributes: attributes)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    func imageWith(newSize: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: newSize)
        let image = renderer.image { _ in
            self.draw(in: CGRect.init(origin: CGPoint.zero, size: newSize))
        }
        return image
    }
}
