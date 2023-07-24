//
//  ContentView.swift
//  MoCrypto
//
//  Created by Corptia on 24/07/2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            Color.theme.background.ignoresSafeArea()
            
            VStack(spacing: 40){
                Text("Accent")
                    .foregroundColor(Color.theme.accent)
                
                Text("Secondery text")
                    .foregroundColor(Color.theme.secondaryText)
                
                Text("Red color")
                    .foregroundColor(Color.theme.red)
                
                Text("Green color")
                    .foregroundColor(Color.theme.green)
            }
            .font(.title)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
