//
//  HomeView.swift
//  Literate
//
//  Created by Nathan Teuber on 5/9/22.
//

import SwiftUI

struct HomeView: View {
    let screen = 0
    @EnvironmentObject var appState: AppState
    var body: some View {
        VStack {
            HeaderView(titleText: "HomeScreen").frame(alignment: .top)
            HomeBodyView().frame(alignment: .center)
            BottomBar(screen: screen)
                .frame(alignment: .bottom)
            
        }
        .frame(minWidth: 0,
            maxWidth: .infinity,
            minHeight: 0,
            maxHeight: .infinity)
        .background(Color.white)
    }
}

struct HomeBodyView: View {
    let screenHeight = UIScreen.main.bounds.height
    let screenWidth = UIScreen.main.bounds.width
    
    var body: some View {
        VStack {
            Text("Welcome to Literate!")
        }
        .frame(width: screenWidth,
               height: (screenHeight * 0.8))
        .background(Color.white)
            
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
