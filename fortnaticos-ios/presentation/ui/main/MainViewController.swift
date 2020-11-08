//
//  MainViewController.swift
//  ios-base
//
//  Created by Wellington Ribeiro on 31/03/20.
//  Copyright © 2020 JWAR. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController, UITabBarControllerDelegate {
        
    override func viewDidLoad() {
        super.viewDidLoad()
                         
        self.delegate = self
        self.title = self.viewControllers?.first?.title
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        self.title = viewController.title
    }

}
