//
//  UIApplication.swift
//  MoCrypto
//
//  Created by Corptia on 25/07/2023.
//

import Foundation
import SwiftUI

extension UIApplication {
    func endEditing(){
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
