//
//  SettingsView.swift
//  MoCrypto
//
//  Created by Corptia on 31/07/2023.
//

import SwiftUI

struct SettingsView: View {
    
    let defaultURL = URL(string: "https://www.google.com")!
    let youtubeURL = URL(string: "https://www.youtube.com/c/swiftfulthinking")!
    let cofeeURL = URL(string: "https://www.buymeaacoffee.com/nicksarno")!
    let coingecoURL = URL(string: "https://www.coingeck.com")!
    let personalUrl = URL(string: "https://github.com")!
    
    var body: some View {
        NavigationStack{
            ZStack{
               
                Color.theme.background
                    .ignoresSafeArea()
                List{
                 swiftfulthinkingSection
                        .listRowBackground(Color.theme.background)
                coinGeckoSection
                        .listRowBackground(Color.theme.background)
                }
                
            }
            
            
            .listStyle(GroupedListStyle())
            .navigationTitle("Settings")
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading) {
                    XMarkButton()
                }
            }
            .scrollContentBackground(Visibility.hidden)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

extension SettingsView{
    
    private var swiftfulthinkingSection : some View{
        Section {
            VStack(alignment: .leading) {
                Image("logo")
                    .resizable()
                    .frame(width: 100 , height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Text("Some text asdfasf sad s s gii ;lkj sdfa d adf akj adsf sdfj l;kjsdf as;lkjf ;kjsdadf ;lkjdf  ijsda dsa  asdf  asdf")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(Color.theme.accent)
            }
            .padding(.vertical)
            Link("Subscribe on YouTube 🥳", destination: youtubeURL)
                .foregroundColor(.blue)
                .font(.headline)
            Link("Support his coffee addiction ☕️", destination: cofeeURL)
                .foregroundColor(.blue)
                .font(.headline)
            
        }
        
    header: {
            Text("Swiftful Thinking")
        }
    }
    
    private var coinGeckoSection : some View{
        Section {
            VStack(alignment: .leading) {
                Image("coingecko")
                    .resizable()
                    .scaledToFit()
                    .frame( height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Text("Some text asdfasf sad s s gii ;lkj sdfa d adf akj adsf sdfj l;kjsdf as;lkjf ;kjsdadf ;lkjdf  ijsda dsa  asdf  asdf")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(Color.theme.accent)
            }
            .padding(.vertical)
            Link("visit coinGecko 🥳", destination: coingecoURL)
                .foregroundColor(.blue)
                .font(.headline)
        }
        
    header: {
            Text("CoinGecko")
        }
    }
}
