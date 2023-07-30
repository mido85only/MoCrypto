//
//  DetailViewModel.swift
//  MoCrypto
//
//  Created by Corptia on 30/07/2023.
//

import Foundation
import Combine

class DetailViewModel : ObservableObject{
    
    @Published var overviewStatistics: [StatisticModel] = []
    @Published var additionalStatistics: [StatisticModel] = []
    @Published var coinDescrption : String? = nil
    @Published var websiteURL : String? = nil
    @Published var redditURL : String? = nil
    
    @Published var coin : CoinModel
    
    private let coinDetailService : CoinDetailDataService
    private var canellables = Set<AnyCancellable>()
    
    init(coin: CoinModel){
        self.coin = coin
        self.coinDetailService = CoinDetailDataService(coin: coin)
        self.addSubscribers()
    }
    
    private func addSubscribers(){
        coinDetailService.$coinDetails
            .combineLatest($coin)
            .map(mapDataToStatistics)
            .sink { [weak self] returnedArryes in
                self?.overviewStatistics = returnedArryes.overview
                self?.additionalStatistics = returnedArryes.additional
            }
            .store(in: &canellables)
        
        coinDetailService.$coinDetails
            .sink { [weak self](returnedCoinDetials) in
                self?.coinDescrption = returnedCoinDetials?.readableDescription
                self?.websiteURL = returnedCoinDetials?.links?.homepage?.first
                self?.redditURL = returnedCoinDetials?.links?.subredditURL
            }
            .store(in: &canellables)
    }
    
    private func mapDataToStatistics(coinDetailModel: CoinDetailModel? , coinModel: CoinModel) -> (overview: [StatisticModel] , additional: [StatisticModel]){
        let overviewArray = createOverviewArray(coinModel: coinModel)
        let additionalArray = createAdditionalArray(coinDetailModel: coinDetailModel, coinModel: coinModel)
        return (overviewArray , additionalArray)
    }
    
    private func createOverviewArray(coinModel: CoinModel) -> [StatisticModel]{
        let price = coinModel.currentPrice.asCurrencyWith6Decimals()
        let pricePercentChange = coinModel.priceChangePercentage24H
        let priceStat = StatisticModel(title: "CurrentPrice", value: price , percentageChange: pricePercentChange)
        
        let marketCap = "$" + (coinModel.marketCap?.formattedWithAbbreviations() ?? "")
        let marketCapPercentChange = coinModel.marketCapChangePercentage24H
        let marketCapStat = StatisticModel(title: "Market Capitalization", value: marketCap , percentageChange: marketCapPercentChange)
        
        let rank = "\(coinModel.rank)"
        let rankStat = StatisticModel(title: "Rank", value: rank)
        
        let volume = "$" + (coinModel.totalVolume?.formattedWithAbbreviations() ?? "")
        let volumeStat = StatisticModel(title: "Volume", value: volume)
        
        let overviewArray: [StatisticModel] = [priceStat , marketCapStat , rankStat , volumeStat]
        
        return overviewArray
    }
    
    private func createAdditionalArray(coinDetailModel: CoinDetailModel? , coinModel: CoinModel) -> [StatisticModel]{
        
        let high = coinModel.high24H?.asCurrencyWith6Decimals() ?? "n/a"
        let highStat = StatisticModel(title: "24h Hith", value: high)
        
        let low = coinModel.low24H?.asCurrencyWith6Decimals() ?? "n/a"
        let lowStat = StatisticModel(title: "24h low", value: low)
        
        let priceChange = coinModel.priceChange24H?.asCurrencyWith6Decimals() ?? "n/a"
        let pricePercentChange = coinModel.priceChangePercentage24H
        let priceChangeStat = StatisticModel(title: "24h Price Change", value: priceChange, percentageChange: pricePercentChange)
        
        let marketCapChange = "$" + (coinModel.marketCapChange24H?.formattedWithAbbreviations() ?? "")
        let marketCapPercentChange = coinModel.marketCapChangePercentage24H
        let marketCapChangeStat = StatisticModel(title: "24h Market Cap Change", value: marketCapChange, percentageChange: marketCapPercentChange)
        
        let blockTime = coinDetailModel?.blockTimeInMinutes ?? 0
        let blockTimeString = blockTime == 0 ? "n/a" : "\(blockTime)"
        let blockStat = StatisticModel(title: "Block Time", value: blockTimeString)
        
        let hashing = coinDetailModel?.hashingAlgorithm ?? "n/a"
        let hasingStat = StatisticModel(title: "Hashing Algorith", value: hashing)
        
        let additionalArray : [StatisticModel] = [
            highStat , lowStat , priceChangeStat , marketCapChangeStat , blockStat , hasingStat
        ]
        
        return additionalArray
    }
    
}
