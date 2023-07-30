//
//  Date.swift
//  MoCrypto
//
//  Created by Corptia on 30/07/2023.
//

import Foundation

extension Date {
    
    init(coinGekoString: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date  = formatter.date(from: coinGekoString) ?? Date()
        self.init(timeInterval: 0 , since: date)
    }
    
    private var shortFormatter: DateFormatter{
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }
    
    func asShortDateToString() -> String{
        return shortFormatter.string(from: self)
    }
}
