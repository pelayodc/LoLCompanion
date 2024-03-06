//
//  SummonerExtendedView.swift
//  LoLCompanion
//
//  Created by Pelayo Del Campo González on 5/3/24.
//

import SwiftUI
import Combine


struct SummonerExtendedView: View {
    @EnvironmentObject var dragonManager: DDragonManager
    
    @ObservedObject var viewModel: SummonerViewViewModel
    
    let myWindow:NSWindow?
    
    var body: some View {
        VStack {
            HStack {
                AsyncImage(url: dragonManager.getProfileURL(for: viewModel.remoteSummoner?.profileIconID ?? 1,
                                                            patchVersions: DDragonManager.shared.lastVersion ?? "")) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 61, height: 61, alignment: .center)
                        .cornerRadius(100)
                        .overlay(
                            Circle()
                                .stroke(LoLCompanionColors.gold.swiftUI, lineWidth: 2)
                        )
                        .padding(.trailing, 8)
                } placeholder: {
                    ProgressView()
                }
                Text(viewModel.remoteSummoner?.name ?? "Not Defined")
                    .font(Font.system(size: 16))
                    .fontWeight(.bold)
            }
            HStack {
                ForEach(viewModel.rankedStatus, id: \.leagueId) { game in
                    RankView(rankstatus: game)
                    Divider()
                }
            }
            Spacer()
            Button("Close") {
                self.myWindow?.close()
            }.buttonStyle(LoLButton())
                .padding(16)
        }
    }
    
}
