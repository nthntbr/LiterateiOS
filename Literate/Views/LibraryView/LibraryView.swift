//
//  LibraryView.swift
//  Literate
//
//  Created by Nathan Teuber on 9/1/22.
//

import SwiftUI

class LibraryState: ObservableObject {
    @Published var libraryBodyState: Int
    @Published var shelfOpen: (String, [String])
    
    init(libraryBodyState: Int, shelfOpen: (String, [String])){
        self.libraryBodyState = libraryBodyState
        self.shelfOpen = shelfOpen
    }
    
    func refreshShelf() {
        let LM = LibraryModel()
        let layout = LM.selectLayout()
        let shelfName = shelfOpen.0
        for shelfTuple in layout {
            if(shelfTuple.0 == shelfName) {
                self.shelfOpen = shelfTuple
            }
        }
    }
    
}

struct LibraryView: View {
    let screen = 2
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var playbackState: PlaybackState
    
    var body: some View {
        VStack {
            HeaderView(titleText: "LibraryScreen")
                .frame(alignment: .top)
            LibraryBodyView()
                .environmentObject(appState)
                .environmentObject(playbackState)
                .frame(alignment: .center)
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


struct LibraryBodyView: View {
    let screenHeight = UIScreen.main.bounds.height
    let screenWidth = UIScreen.main.bounds.width
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var playbackState: PlaybackState
    @ObservedObject var libraryState = LibraryState(libraryBodyState: 0, shelfOpen: ("", []))
    
    
    
    var body: some View {
        VStack {
            if(self.libraryState.libraryBodyState == 0) {
                LibraryShelvesBodyView()
                    .environmentObject(libraryState)
            } else if(self.libraryState.libraryBodyState == 1) {
                ShelfBodyView()
                    .environmentObject(libraryState)
                    .environmentObject(appState)
                    .environmentObject(playbackState)
                
            } else if(self.libraryState.libraryBodyState == 2) {
                LibraryEditView()
                    .environmentObject(libraryState)
                    .environmentObject(appState)
            }
        }
        .frame(width: screenWidth, height: (screenHeight * 0.8))
    }
    
    
    
}


struct LibraryView_Previews: PreviewProvider {
    static var previews: some View {
        LibraryView()
            .previewDevice("iPhone 13")
    }
}
