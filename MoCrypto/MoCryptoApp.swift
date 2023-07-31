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
    @State private var showLaunchView = true
    init(){
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor : UIColor(Color.theme.accent)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor : UIColor(Color.theme.accent)]
        UINavigationBar.appearance().tintColor =  UIColor(Color.theme.accent)
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack{
                NavigationStack{
                    HomeView()
                        .navigationBarHidden(true)
                }
                .environmentObject(vm)
                
                ZStack{
                    if showLaunchView {
                        LaunchView(showLanunchView: $showLaunchView)
                            .transition(.move(edge: .leading))
                    }
                }
                .zIndex(2.0)
               
            }
            
        }
    }
}
