//
//  HomeView.swift
//  MoCrypto
//
//  Created by Corptia on 24/07/2023.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var vm: HomeViewModel

    @State private var showPortfolio = false  //animate right
    @State private var shorPortfolioView = false //new sheet
   
    var body: some View {
        ZStack{
            //back ground layer
            Color.theme.background.ignoresSafeArea()
                .sheet(isPresented: $shorPortfolioView) {
                    PortfolioView()
                        .environmentObject(vm)
                }
            // content layer
            VStack{
                homeHeader
                HomeStatsView(showPortfolio: $showPortfolio)
                SearchBarView(searchText: $vm.searchText)
                colomnTitles
                if !showPortfolio{
                    allCoinsList
                    .transition(.move(edge: .leading))
                }
                
                if showPortfolio {
                    portfolioCoinsList
                        .transition(.move(edge: .trailing))
                }
                Spacer(minLength: 0)
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            HomeView()
        }
        .environmentObject(dev.homeVM)
    }
}

extension HomeView {
    private var homeHeader: some View{
        HStack{
            CircleButtonView(iconName: showPortfolio ? "plus" : "info")
                .animation(.none, value: showPortfolio)
                .onTapGesture {
                    if showPortfolio {
                        shorPortfolioView.toggle()
                    }
                }
                .background(CircleButtonAnimationView(animate: $showPortfolio))
            Spacer()
            Text(showPortfolio ? "Portfolio" : "Live prices")
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundColor(Color.theme.accent)
                .animation(.none, value: showPortfolio)
            Spacer()
            CircleButtonView(iconName: "chevron.right")
                .rotationEffect(Angle(degrees: showPortfolio ? 180 : 0))
                .onTapGesture {
                    withAnimation(.spring()){
                        showPortfolio.toggle()
                    }
                }
        }
        .padding(.horizontal)
    }
    
    private var allCoinsList: some View{
        List{
            ForEach(vm.allCoins) { coin in
                CoinRowView(coin: coin, showHoldingColumn: false)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
            }
        }
        .refreshable {
            vm.reloadData()
        }
        .listStyle(PlainListStyle())
    }
    
    private var portfolioCoinsList: some View{
        List{
            ForEach(vm.portfolioCoins) { coin in
                CoinRowView(coin: coin, showHoldingColumn: true)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
            }
        }
        .listStyle(PlainListStyle())
    }
    
    private var colomnTitles: some View{
        HStack{
            HStack {
                Text("Coin")
                Image(systemName: "chevron.down")
                    .opacity((vm.sortOption == .rank || vm.sortOption == .rankReversed) ? 1 : 0)
                    .rotationEffect(Angle(degrees: vm.sortOption == .rank ? 0 : 180))
            }
            .onTapGesture {
                withAnimation(.default){
                    vm.sortOption = vm.sortOption == .rank ? .rankReversed : .rank
                }
            }
            Spacer()
            if showPortfolio{
                HStack {
                    Text("Holdings")
                    Image(systemName: "chevron.down")
                        .opacity((vm.sortOption == .holdings || vm.sortOption == .holdingsREversed) ? 1 : 0)
                        .rotationEffect(Angle(degrees: vm.sortOption == .holdings ? 0 : 180))

                }
                .onTapGesture {
                    withAnimation(.default){
                        vm.sortOption = vm.sortOption == .holdings ? .holdingsREversed : .holdings
                    }
                }
            }
            HStack {
                Text("Prices")
                Image(systemName: "chevron.down")
                    .opacity((vm.sortOption == .price || vm.sortOption == .priceReverced) ? 1 : 0)
                    .rotationEffect(Angle(degrees: vm.sortOption == .price ? 0 : 180))

            }
            .frame(width: UIScreen.main.bounds.width / 3.5 , alignment: .trailing)
            .onTapGesture {
                withAnimation(.default){
                    vm.sortOption = vm.sortOption == .price ? .priceReverced : .price
                }
            }
        }
        .font(.caption)
        .foregroundColor(Color.theme.secondaryText)
        .padding(.horizontal)
    }
}
