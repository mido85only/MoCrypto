//
//  LaunchView.swift
//  MoCrypto
//
//  Created by Corptia on 31/07/2023.
//

import SwiftUI

struct LaunchView: View {
    
    @State private var loadingText :[String] = "Loading your portfolio...".map{ String($0)}
    @State private var showLoadingText = false
    private let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    @State private var counter = 0
    @State private var loops = 0
    @Binding var showLanunchView : Bool
    
    var body: some View {
        ZStack{
            Color.launch.background
                .ignoresSafeArea()
            
            Image("logo-transparent")
                .resizable()
                .frame(width: 100 , height: 100)
            ZStack{
                if showLoadingText{
                    HStack(spacing: 0){
                        ForEach(loadingText.indices, id: \.self){index in
                            Text(loadingText[index])
                                .font(.headline)
                                .fontWeight(.heavy)
                                .foregroundColor(Color.launch.accent)
                                .offset(y: counter == index ? -5 : 0)
                        }
                    }
                    .transition(AnyTransition.scale.animation(.easeIn))
                }
            }
            .offset(y:70)
        }
        .onAppear{showLoadingText.toggle()}
        .onReceive(timer) { _ in
            withAnimation(.spring()){
                let lastIndex = loadingText.count - 1
                
                if counter == lastIndex{
                    counter = 0
                    loops += 1
                    
                    showLanunchView = !(loops >= 2)
                }else{
                    counter += 1
                }
            }
        }
    }
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView(showLanunchView: .constant(true))
    }
}
