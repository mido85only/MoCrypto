//
//  PortfolioDataService.swift
//  MoCrypto
//
//  Created by Corptia on 26/07/2023.
//

import Foundation
import CoreData

class PortfolioDataService{
    
    private let container: NSPersistentContainer
    private let containerName: String = "PortfolioContainer"
    private let entityName = "PortfolioEntity"
    
    @Published var savedEntities: [PortfolioEntity] = []
    
    init(){
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { _, error in
            if let error = error{
                print("Error loading Core data! \(error)")
            }
            self.getPortfolio()
        }
    }
    
    private func getPortfolio(){
        let request = NSFetchRequest<PortfolioEntity>(entityName: entityName)
        
        do {
           savedEntities =  try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching portfolio Entities . \(error)")
        }
    }
    
    // MARK: PUBLIC
    
    func updatePortfolio(coin: CoinModel , amount: Double){
        
        if let entity = savedEntities.first(where: {$0.coinID == coin.id}){
            if amount > 0 {
                update(entity: entity, amout: amount)
            }else{
                delete(entity: entity)
            }
        }else{
            add(coin: coin, amount: amount)
        }
       
    }
    
    // MARK: PRIVATE
    
    private func add(coin:CoinModel , amount: Double){
        let entity = PortfolioEntity(context: container.viewContext)
        entity.coinID = coin.id
        entity.amount = amount
        applyChanges()
    }
    
    private func update(entity: PortfolioEntity , amout: Double){
        entity.amount = amout
        applyChanges()
    }
    
    private func delete(entity: PortfolioEntity){
        container.viewContext.delete(entity)
        applyChanges()
    }
    
    private func save(){
        do {
            try container.viewContext.save()
        } catch let error {
            print("Error Saving to core data. \(error)")
        }
    }
    
    private func applyChanges(){
        save()
        getPortfolio()
    }
}