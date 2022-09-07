//
//  LibraryView.swift
//  Literate
//
//  Created by Nathan Teuber on 9/1/22.
//

import SwiftUI

class LibraryState: ObservableObject {
    @Published var libraryBodyState: Int
    
    init(libraryBodyState: Int){
        self.libraryBodyState = libraryBodyState
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
    @ObservedObject var libraryState = LibraryState(libraryBodyState: 0)
    @State var shelf: (String, [String]) = ("", [])
    
    
    var body: some View {
        VStack {
            if(self.libraryState.libraryBodyState == 0) {
                LibraryShelvesView(shelf: $shelf)
                    .environmentObject(libraryState)
            } else if(self.libraryState.libraryBodyState == 1) {
                ShelfView(shelf: $shelf)
                    .environmentObject(libraryState)
                    .environmentObject(appState)
                    .environmentObject(playbackState)
                
            } else if(self.libraryState.libraryBodyState == 2) {
                LibraryEditView(shelf: $shelf)
                    .environmentObject(libraryState)
                    .environmentObject(appState)
            }
        }
        .frame(width: screenWidth, height: (screenHeight * 0.8))
    }
    
    
    
}

struct LibraryShelvesView: View {
    @Binding var shelf: (String, [String])
    @EnvironmentObject var libraryState: LibraryState
    let screenHeight = UIScreen.main.bounds.height
    let screenWidth = UIScreen.main.bounds.width
    //private var layout: [String: [String]]
    
    var body: some View {
        let layout = getLayout()
        VStack{
            ForEach(layout, id: \.0) { shelfTuple in
                Button(action: {
                    shelf = shelfTuple
                    self.libraryState.libraryBodyState = 1
                    
                }, label: {Text(shelfTuple.0)})
            }
        }
    }
    
    func getLayout() -> [(String, [String])] {
        let LM = LibraryModel()
        return LM.selectLayout()
    }
}

struct ShelfView: View {
    @Binding var shelf: (String, [String])
    @EnvironmentObject var libraryState: LibraryState
    @EnvironmentObject var playbackState: PlaybackState
    @EnvironmentObject var appState: AppState

    let screenHeight = UIScreen.main.bounds.height
    let screenWidth = UIScreen.main.bounds.width
    
    
    var body: some View {
        let viewHeight = (screenHeight * 0.8)
        VStack{
            let shelfName = shelf.0
            let bookList = shelf.1
            HStack {
                Spacer()
                Text(shelfName)
                    .frame(alignment: .center)
                    .padding()
                Spacer()
            }
            .frame(width: screenWidth, height: (viewHeight * 0.075), alignment: .topLeading)
            
            
            VStack{
                ForEach(bookList, id: \.count) { bookName in
                    Button(action: {
                        print("Book Selected!")
                        appState.bookOpen = bookName
                        playbackState.bookOpen = bookName
                        appState.screenOpen = 3
                    }, label: {Text(bookName)})
                        .padding()
                }
            }
            .frame(height: (viewHeight * 0.85), alignment: .center)
            
            HStack {
                Spacer()
                Button(action: {self.libraryState.libraryBodyState = 0}, label: {Text("Back")})
                    .padding()
                Spacer()
                Button(action: {}, label: <#T##() -> Label#>)
            }
            .frame(width: screenWidth, height: (viewHeight * 0.075), alignment: .bottomTrailing)
            
            
        }.frame(width: screenWidth, height: viewHeight)
    }
}



struct LibraryView_Previews: PreviewProvider {
    static var previews: some View {
        LibraryView()
            .previewDevice("iPhone 13")
    }
}
