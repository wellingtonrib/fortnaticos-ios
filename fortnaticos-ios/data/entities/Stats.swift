//
//  Stats.swift
//  fortnaticos-ios
//
//  Created by Well on 03/11/20.
//  Copyright © 2020 JWAR. All rights reserved.
//

import Foundation

struct StatsDTO: Codable {
    var data: UserStats!
}

struct UserStats: Codable {
    var account: Account!
    var battlePass: BattlePass!
    var stats: Stats!
}

struct StatsType: Codable {
    var overall: StatsValues!
    var solo: StatsValues!
    var duo: StatsValues!
    var trio: StatsValues!
    var squad: StatsValues!
}

struct Stats: Codable {
    var all: StatsType!
}

struct StatsValues: Codable {
    var score : Int!
    var scorePerMin : Double!
    var scorePerMatch: Double!
    var wins: Int!
    var kills: Int!
    var kd: Double!
    var deaths: Int!
    var matches : Int!
    var top1: Int!
    var top3: Int!
    var top5: Int!
    var top10: Int!
    var top25: Int!
}

struct Account: Codable {
    var name : String!
}

struct BattlePass: Codable {
    var level : Int!
}


