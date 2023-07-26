//
//  MarketDataService.swift
//  MoCrypto
//
//  Created by Corptia on 25/07/2023.
//

import Foundation

import Combine

class MarketDataService {
    
    @Published var marketData: MarketDataModel? = nil
//    var cancellables = Set<AnyCancellable>()
    
    var marketDataSubscription : AnyCancellable?
    init() {
        getMarketData()
    }
    
    private func getMarketData(){
        
        guard let url = URL(string: "https://api.coingecko.com/api/v3/global") else {return}
        
        marketDataSubscription =  NetworkingManager.download(url: url)
            .decode(type: GlobalData.self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: {[weak self] (retunedGlobalData) in
                self?.marketData = retunedGlobalData.data
                self?.marketDataSubscription?.cancel()
            })
            

        
    }
}
