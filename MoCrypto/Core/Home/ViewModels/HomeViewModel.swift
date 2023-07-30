//
//  HomeViewModel.swift
//  MoCrypto
//
//  Created by Corptia on 24/07/2023.
//

import Foundation
import Combine

class HomeViewModel : ObservableObject{
    
    @Published var statistics: [StatisticModel] = []
    @Published var allCoins: [CoinModel] = []
    @Published var portfolioCoins: [CoinModel] = []
    @Published var searchText = ""
    @Published var sortOption : SortOption = .holdings
    
    private let coindDataService = CoinDataService()
    private let marketDataService = MarketDataService()
    private let portfolioDataService = PortfolioDataService()
    private var cancellables = Set<AnyCancellable>()
    
    enum SortOption{
        case rank , rankReversed , holdings , holdingsREversed , price , priceReversed
    }
    
    init(){
        addSubscribers()
    }
    
    func addSubscribers(){
//        dataService.$allCoins
//            .sink { [weak self] (retunedCoins) in
//                self?.allCoins = retunedCoins
//            }
//            .store(in: &cancellables)
        
        // updates allCoins
        $searchText
            .combineLatest(coindDataService.$allCoins , $sortOption)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterAndSortCoins)
            .sink { [weak self] retunedCoins in
                self?.allCoins = retunedCoins
            }
            .store(in: &cancellables)
        
        // updates portfolioCoins
        $allCoins.combineLatest(portfolioDataService.$savedEntities)
            .map(mapAllCoinsToPortfolioCoins)
            .sink { [weak self] returnedCoins in
                guard let self = self else {return}
                self.portfolioCoins = self.sortPortfolioCoinsIfNeeded(coins: returnedCoins)
            }
            .store(in: &cancellables)
        
        // updates marketData
        marketDataService.$marketData
            .combineLatest($portfolioCoins)
            .map(mapGlobalMarketData)
            .sink { [weak self] returnedStats in
                self?.statistics = returnedStats
            }
            .store(in: &cancellables)

    }
    
    func updatePortfolio(coin: CoinModel, amount: Double){
        portfolioDataService.updatePortfolio(coin: coin, amount: amount)
    }
    
    func reloadData(){
        coindDataService.getCoins()
        marketDataService.getMarketData()
        HapticManager.notification(type: .success)
    }
    
    private func filterAndSortCoins(text:String , coins: [CoinModel] , sort: SortOption) -> [CoinModel]{
         var updatedCoins =  filterCoins(text: text, coins: coins)
        sortCoins(sort: sort, coins: &updatedCoins)
        
        return updatedCoins
    }
    
    private func filterCoins(text:String , coins: [CoinModel] ) -> [CoinModel]{
        guard !text.isEmpty else {
            return coins
        }
        
        let lowercasedText = text.lowercased()
        return coins.filter { coin in
            return coin.name.lowercased().contains(lowercasedText) ||
            coin.symbol.lowercased().contains(lowercasedText) ||
            coin.id.lowercased().contains(lowercasedText)
        }
    }
    
    private func sortCoins(sort: SortOption , coins: inout [CoinModel]){
        switch sort {
        case .rank , .holdings:
             coins.sort(by: {$0.rank < $1.rank})
        case.rankReversed , .holdingsREversed:
             coins.sort(by: {$0.rank > $1.rank})
        case.price:
             coins.sort(by: {$0.currentPrice > $1.currentPrice})
        case.priceReversed:
             coins.sort(by: {$0.currentPrice < $1.currentPrice})
            
        }
    }
    
    private func sortPortfolioCoinsIfNeeded(coins: [CoinModel]) -> [CoinModel]{
        switch sortOption {
        case .holdings:
            return coins.sorted(by: {$0.currentHoldingsValue > $1.currentHoldingsValue})
        case.holdingsREversed:
            return coins.sorted(by: {$0.currentHoldingsValue < $1.currentHoldingsValue})
        default:
            return coins
        }
    }
    
    private func mapAllCoinsToPortfolioCoins(coinModels: [CoinModel] , portfolioEntities: [PortfolioEntity]) -> [CoinModel]{
        coinModels
            .compactMap { coin -> CoinModel? in
                guard let entity = portfolioEntities.first(where: {$0.coinID == coin.id}) else{
                    return nil
                }
                return coin.updateHoldings(amount: entity.amount)
            }
    }
    
    private func mapGlobalMarketData(marketDataModel: MarketDataModel? , portfolioCoins: [CoinModel]) -> [StatisticModel]{
        var stats: [StatisticModel] = []
        
        guard let data = marketDataModel else {
            return stats
        }
        
        let marketCap = StatisticModel(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
        
        let volume = StatisticModel(title: "24h volume", value: data.volume)
        let btcDominance = StatisticModel(title: "BTC Dominance", value: data.btcDominance)
        
        let portfolioValue = portfolioCoins.map({$0.currentHoldingsValue})
            .reduce(0, +)
        
        let previousValue = portfolioCoins
            .map { coin -> Double in
                let currentValue = coin.currentHoldingsValue
                let precentChange = coin.priceChangePercentage24H ?? 0 / 100
                let previousValue = currentValue / (1 + precentChange)
                return previousValue
            }
            .reduce(0, +)
  
        let percentageChange = ((portfolioValue - previousValue) / previousValue)
        
        let portfolio = StatisticModel(title: "Portfolio value", value: portfolioValue.asCurrencyWith2Decimals(), percentageChange: percentageChange)
        
        stats.append(contentsOf: [marketCap , volume , btcDominance , portfolio])
        
        return stats
    }
}
