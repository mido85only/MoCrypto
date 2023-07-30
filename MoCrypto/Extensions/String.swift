//
//  String.swift
//  MoCrypto
//
//  Created by Corptia on 30/07/2023.
//

import Foundation

extension String {
    var removingHTMLOccurances: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "" , options: .regularExpression , range: nil)
    }
}
