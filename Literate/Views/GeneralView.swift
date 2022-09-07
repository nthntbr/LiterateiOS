//
//  GeneralView.swift
//  Literate
//
//  Created by Nathan Teuber on 5/9/22.
//

import SwiftUI

struct HeaderView: View {
    let screenHeight = UIScreen.main.bounds.height
    let screenWidth = UIScreen.main.bounds.width
    var titleText: String
    
    
    init(titleText: String){
        self.titleText = titleText
        
        
    }
    
    
    var body: some View {
        HStack {
            Spacer()
                .frame(width: (self.screenWidth * 0.3))
            Text(titleText)
                .frame(width: (self.screenWidth * 0.4))
            Spacer()
                .frame(width: (self.screenWidth * 0.05))
            Button(action: {}, label: {Image(systemName: "gearshape")})
                .frame(width: (self.screenWidth * 0.25))
            
        }
        .frame(width: screenWidth,
               height: (screenHeight * 0.05),
               alignment: .center)
        .background(Color.gray)
    }
    
}

struct BottomBar: View {
    var screen: Int
    let screenHeight = UIScreen.main.bounds.height
    let screenWidth = UIScreen.main.bounds.width
    @EnvironmentObject var appState: AppState
    var homeIcon: String {
        if(self.screen == 0){
            return "house.fill"
        }
        return "house"
    }
    var addBookIcon: String {
        if(self.screen == 1){
            return "plus.app.fill"
        }
        return "plus.app"
    }
    var libraryIcon: String {
        if(self.screen == 2){
            return "books.vertical.fill"
        }
        return "books.vertical"
    }
    
    init(screen: Int){
        self.screen = screen
    }
    
    var body: some View {
        HStack {
            Spacer()
            Button(action: {appState.screenOpen = 1},
                   label: {Image(systemName: addBookIcon)})
            .frame(height: (screenHeight * 0.05))
            Spacer()
            Button(action: {appState.screenOpen = 0},
                   label: {Image(systemName: homeIcon)})
            .frame(height: (screenHeight * 0.05))
            Spacer()
            Button(action: {appState.screenOpen = 2},
                   label: {Image(systemName: libraryIcon)})
            .frame(height: (screenHeight * 0.05))
            Spacer()
        }
        .frame(width: screenWidth,
               height: (screenHeight * 0.05),
               alignment: .bottom)
        .background(Color.white)
    
    }
}

