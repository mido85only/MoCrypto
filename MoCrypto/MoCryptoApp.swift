//
//  MoCryptoApp.swift
//  MoCrypto
//
//  Created by Corptia on 24/07/2023.
//

import SwiftUI

@main
struct MoCryptoApp: App {
    
    @StateObject private var vm = HomeViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack{
                HomeView()
                    .navigationBarHidden(true)
            }
            .environmentObject(vm)
        }
    }
}
