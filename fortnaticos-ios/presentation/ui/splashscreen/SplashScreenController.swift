//
//  SplashScreenController.swift
//  ios-base
//
//  Created by Wellington Ribeiro on 23/03/20.
//  Copyright © 2020 JWAR. All rights reserved.
//

import UIKit

class SplashScreenController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.performSegue(withIdentifier: "mainSegue", sender: nil)
        })
    }
}
