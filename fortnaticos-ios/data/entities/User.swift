//
//  Usuario.swift
//  ios-base
//
//  Created by Wellington Ribeiro on 23/03/20.
//  Copyright © 2020 JWAR. All rights reserved.
//

import Foundation

struct User: Codable {
    var id = 0
    var name : String?
    var email : String?
    var password : String?
    var current_password : String?
    var photo : String?
    var photo_url : String?
}

