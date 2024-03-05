//
//  LeagueEntry.swift
//  LoLCompanion
//
//  Created by Jean-Louis Darmon on 25/01/2023.
//

import Foundation

struct RankedStatus: Codable {
    let leagueId, queueType: String
    let tier, rank: String
    let summonerId, summonerName: String
    let leaguePoints, wins, losses: Int
    let veteran, inactive, freshBlood, hotStreak: Bool
}

struct MiniSeries: Codable {
    let losses: Int
    let progress: String
    let target, wins: Int
}
