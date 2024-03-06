//
//  RankView.swift
//  LoLCompanion
//
//  Created by Pelayo Del Campo González on 6/3/24.
//

import SwiftUI

struct RankView: View {
    var rankstatus: RankedStatus
    var body: some View {
        VStack {
            Text(rankstatus.queueType)
            HStack {
                Text(rankstatus.rank)
                Text(rankstatus.tier)
            }
            HStack {
                Text(String(rankstatus.leaguePoints))
                Text("LP")
            }
            HStack {
                Text(String(rankstatus.wins))
                    .foregroundColor(LoLCompanionColors.victory.swiftUI)
                    .font(Font.system(size: 14))
                    .fontWeight(.medium)
                Text("/")
                Text(String(rankstatus.losses))
                    .foregroundColor(LoLCompanionColors.defeat.swiftUI)
                    .font(Font.system(size: 14))
                    .fontWeight(.medium)
            }
        }
    }
}

