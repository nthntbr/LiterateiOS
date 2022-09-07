//
//  LiterateApp.swift
//  Literate
//
//  Created by Nathan Teuber on 5/9/22.
//

import SwiftUI

class AppState: ObservableObject {
    @Published var screenOpen: Int
    @Published var bookOpen: String
    
    init(screenOpen: Int, bookOpen: String){
        self.screenOpen = screenOpen
        self.bookOpen = bookOpen
    }
}

class PlaybackState: ObservableObject {
    @Published var pageOpen: Int
    @Published var bookOpen: String
    var book: (String, [Int: [String]]) {
        let pbm = PlaybackModel(bookOpen: self.bookOpen)
        return pbm.book
    }
    
    
    init(pageOpen: Int, bookOpen: String) {
        self.pageOpen = pageOpen
        self.bookOpen = bookOpen

        
    }
}


@main
struct literateApp: App {
    @ObservedObject var appState = AppState(screenOpen: 0, bookOpen: "")
    @ObservedObject var playbackState = PlaybackState(pageOpen: 0, bookOpen: "")
    
    var body: some Scene {
        WindowGroup {
            
            if(self.appState.screenOpen == 1 ){
                AddBookView()
                    .environmentObject(appState)
            } else if (self.appState.screenOpen == 2){
                LibraryView()
                    .environmentObject(appState)
                    .environmentObject(playbackState)
            } else if(self.appState.screenOpen == 3){
                PlaybackView()
                    .environmentObject(appState)
                    .environmentObject(playbackState)
            } else {
                HomeView()
                    .environmentObject(appState)
            }
        }
    }
}

