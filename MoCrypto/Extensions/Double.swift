//
//  Double.swift
//  MoCrypto
//
//  Created by Corptia on 24/07/2023.
//

import Foundation

extension Double {
    
    
    /// Converts  a Double into Currence with 2 decimal places
    /// ```
    /// Convert 1234.56 to $1,234.56
    ///  ```
    private var currenceFormatter2: NumberFormatter{
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
//        formatter.locale = .current
//        formatter.currencyCode = "usd"
//        formatter.currencySymbol = "$"
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }
    
    /// Converts  a Double into Currence  as a Stringwith 2 decimal places
    /// ```
    /// Convert 1234.56 to "$1,234.56"
    ///  ```
    func asCurrencyWith2Decimals() -> String{
        let number  = NSNumber(value: self)
        return currenceFormatter2.string(from: number) ?? "$0.00"
    }
    
    
    /// Converts  a Double into Currence with 2 -6 decimal places
    /// ```
    /// Convert 1234.56 to $1,234.56
    /// Convert 12.3456 to $12,3456
    /// Convert 0.123456 to $0,123456
    ///  ```
    private var currenceFormatter6: NumberFormatter{
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
//        formatter.locale = .current
//        formatter.currencyCode = "usd"
//        formatter.currencySymbol = "$"
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 6
        return formatter
    }
    
    /// Converts  a Double into Currence  as a Stringwith 2 -6 decimal places
    /// ```
    /// Convert 1234.56 to "$1,234.56"
    /// Convert 12.3456 to "$12,3456"
    /// Convert 0.123456 to "$0,123456"
    ///  ```
    func asCurrencyWith6Decimals() -> String{
        let number  = NSNumber(value: self)
        return currenceFormatter6.string(from: number) ?? "$0.00"
    }
    
    /// Converts  a Double into string representation
    /// ```
    /// Convert 1.23456 to "$1.23"
    ///  ```
    func asNumberString() -> String{
        return String(format: "%.2f" , self)
    }
    
    func asPercentString() -> String{
        return asNumberString() + "%"
    }
}
