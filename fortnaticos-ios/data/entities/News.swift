//
//  News.swift
//  fortnaticos-ios
//
//  Created by Well on 07/11/20.
//  Copyright © 2020 JWAR. All rights reserved.
//

import Foundation

struct NewsDTO: Codable {
    var data: NewsData!
}

struct NewsData: Codable {
    var image: String!
    var motds: [NewsMotd]
}

struct NewsMotd: Codable {
    var title: String!
    var body: String!
    var image: String!
    var tileImage: String!
}
