//
//  File.swift
//  fortnaticos-ios
//
//  Created by Well on 04/11/20.
//  Copyright © 2020 JWAR. All rights reserved.
//

import Foundation

struct StoreDTO: Codable {
    var data: StoreData!
}

struct StoreData: Codable {
    var featured: StoreType!
    var daily: StoreType!
}

struct StoreType: Codable {
    var name: String!
    var entries: [StoreEntry]
}

struct StoreEntry: Codable {
    var finalPrice: Int!
    var items: [StoreEntryItem]
}

struct StoreEntryItem: Codable {
    var name: String!
    var images: StoreImage!
}

struct StoreImage: Codable {
    var featured: String?
    var smallIcon: String?
    var icon: String?
}
