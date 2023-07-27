//
//  HapticManager.swift
//  MoCrypto
//
//  Created by Corptia on 27/07/2023.
//

import Foundation
import SwiftUI


class HapticManager{
    static private let generator = UINotificationFeedbackGenerator()
    
    static func notification(type: UINotificationFeedbackGenerator.FeedbackType){
        generator.notificationOccurred(type)
    }
}
