//
//  CoinImageViewModel.swift
//  MoCrypto
//
//  Created by Corptia on 25/07/2023.
//

import Foundation
import SwiftUI
import Combine

class CoinImageViewModel: ObservableObject{
    
    @Published var image: UIImage? = nil
    @Published var isLoading = false
    
    private let coin: CoinModel
    private let dataService : CoinImageSerivce
    private var cancellables = Set<AnyCancellable>()
    
    init(coin: CoinModel){
        self.coin = coin
        self.dataService = CoinImageSerivce(coin: coin)
        addSubscribers()
        self.isLoading = true
    }
    
    private func addSubscribers(){
        
        dataService.$image
            .sink { [weak self] _ in
                self?.isLoading = false
            } receiveValue: { [weak self] returnedImage in
                self?.image = returnedImage
            }
            .store(in: &cancellables)

    }
}
