//
//  SummonerView.swift
//  LoLCompanion
//
//  Created by Jean-Louis Darmon on 22/01/2023.
//

import SwiftUI
import Combine

class SummonerViewViewModel: ObservableObject {
    private var lolManager: LoLManager
    private var scope = Set<AnyCancellable>()

    @Published var localSummoner: Summoner?
    @Published var remoteSummoner: Summoner?
    @Published var rankedStatus: [RankedStatus] = []

    init(lolManager: LoLManager) {
        self.lolManager = lolManager
        observeData()
    }

    private func observeData() {
        lolManager.$localSummoner
            .receive(on: RunLoop.main)
            .sink { localSummoner in
                self.localSummoner = localSummoner
            }.store(in: &scope)

        lolManager.$remoteSummoner
            .receive(on: RunLoop.main)
            .sink { remoteSummoner in
                self.remoteSummoner = remoteSummoner
            }.store(in: &scope)

        lolManager.$rankedStatus
            .receive(on: RunLoop.main)
            .sink {
                self.rankedStatus = $0
            }.store(in: &scope)
    }

    func updateData() {
        Task {
            lolManager.updateLocalSummoner()
            await lolManager.updateRemoteSummoner()
            if let summonerId = lolManager.remoteSummoner?.id {
                await lolManager.getRankedStatus(for: summonerId)
            }
        }
    }

}

struct SummonerView: View {
    @EnvironmentObject var dragonManager: DDragonManager

    @ObservedObject var viewModel: SummonerViewViewModel

    var body: some View {
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
            VStack(alignment: .leading) {
                Text(viewModel.remoteSummoner?.name ?? "Not Defined")
                    .font(Font.system(size: 16))
                    .fontWeight(.bold)
                HStack {
                    Text(viewModel.rankedStatus.first(where: {$0.queueType=="RANKED_SOLO_5x5"})?.tier ?? "Not Ranked")
                        .font(Font.system(size: 14))
                        .fontWeight(.medium)
                    Text(viewModel.rankedStatus.first(where: {$0.queueType=="RANKED_SOLO_5x5"})?.rank ?? "")
                        .font(Font.system(size: 14))
                        .fontWeight(.medium)
                }
                HStack {
                    Text(String( viewModel.rankedStatus.first(where: {$0.queueType=="RANKED_SOLO_5x5"})?.leaguePoints ?? 0))
                        .font(Font.system(size: 14))
                        .fontWeight(.medium)
                    Text("LP")
                }
                if let rankedStatus = viewModel.rankedStatus.first(where: {$0.queueType=="RANKED_SOLO_5x5"}) {
                    HStack {
                        Text(String(rankedStatus.wins))
                            .foregroundColor(LoLCompanionColors.victory.swiftUI)
                            .font(Font.system(size: 14))
                            .fontWeight(.medium)
                        Text("/")
                        Text(String(rankedStatus.losses))
                            .foregroundColor(LoLCompanionColors.defeat.swiftUI)
                            .font(Font.system(size: 14))
                            .fontWeight(.medium)
                    }
                }
            }
            Spacer()
        }
//        VStack {
//            Text("User Local Data")
//            if let localSummoner = viewModel.localSummoner {
//                comonUserDateView(for: localSummoner)
//            }
//            Divider()
//            Text("User Remote Data")
//            if let remoteSummoner = viewModel.remoteSummoner {
//                comonUserDateView(for: remoteSummoner)
//
//                if let profileIconId = remoteSummoner.profileIconID,
//                   let revisionDate = remoteSummoner.revisionDate,
//                    let summonerLevel = remoteSummoner.summonerLevel {
//                    Text("Profile Icon ID: \(profileIconId)")
//                    Text("Revision Date: \(revisionDate)")
//                    Text("Summoner Level: \(summonerLevel)")
//                }
//            }
//        }

        .task {
            viewModel.updateData()
        }
        .padding(16)
        .frame(width: 200, height: 60, alignment: .center)
        .onTapGesture {
            print("TODO load profileData")
            
        }
    }

    func comonUserDateView(for summoner: Summoner) -> some View {
        VStack(alignment: .leading) {
            Text("ID: \(summoner.id)")
            Text("Account ID: \(summoner.accountID)")
            Text("PUUID: \(summoner.puuid)")
                .onTapGesture {
                    print(summoner.puuid)
                    NSPasteboard.general.setString(summoner.puuid, forType: .string)
                }
            Text("Name: \(summoner.name)")
        }
    }
}

struct SummonerView_Previews: PreviewProvider {
    static var previews: some View {
        SummonerView(viewModel: SummonerViewViewModel(lolManager: LoLManager()))
    }
}
