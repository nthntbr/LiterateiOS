//
//  LiterateApp.swift
//  Literate
//
//  Created by Nathan Teuber on 5/9/22.
//

import SwiftUI

class AppState: ObservableObject {
    @Published var screenOpen: Int
    
    init(screenOpen: Int){
        self.screenOpen = screenOpen
    }
}

@main
struct literateApp: App {
    @ObservedObject var appState = AppState(screenOpen: 0)
    
    var body: some Scene {
        WindowGroup {
            
            if(self.appState.screenOpen == 1 ){
                AddBookView()
                    .environmentObject(appState)
            } else {
                HomeView()
                    .environmentObject(appState)
            }
        }
    }
}

