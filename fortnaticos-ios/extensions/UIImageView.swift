//
//  UIImageView.swift
//  WTP
//
//  Created by Wellington Ribeiro on 21/02/2019.
//  Copyright © 2019 Luiz Soares. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

extension UIImageView {
    
    func asCircle() -> UIImageView {
        self.contentMode = UIView.ContentMode.scaleAspectFill
        self.layer.cornerRadius = self.frame.height / 2;
        self.layer.masksToBounds = false
        self.clipsToBounds = true
        return self
    }
    
    func load(url: String?, placeholder: UIImage? = nil, errorImage: UIImage? = nil, completion: ((UIImage?)->Void)? = nil) -> UIImageView {
        self.kf.setImage(with: URL(string: url ?? ""), placeholder: placeholder, options: [.transition(.fade(0.1))], progressBlock: nil) { result in
            switch (result) {
            case .success:
                if let callback = completion { callback(self.image) }
                break
            case .failure:
                self.image = errorImage
                break
            }
        }
        return self
    }
    
    
}
