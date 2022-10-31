//
//  ShelfBodyView.swift
//  Literate
//
//  Created by Nathan Teuber on 10/12/22.
//

import SwiftUI


struct ShelfBodyView: View {
    @EnvironmentObject var libraryState: LibraryState
    @EnvironmentObject var playbackState: PlaybackState
    @EnvironmentObject var appState: AppState

    let screenHeight = UIScreen.main.bounds.height
    let screenWidth = UIScreen.main.bounds.width
    
    
    var body: some View {
        let shelf = libraryState.shelfOpen
        let viewHeight = (screenHeight * 0.8)
        let shelfName = shelf.0
        let bookList = shelf.1
        let sc = ShelfContents(bookList: bookList)
        let content = sc.addElements()
        
        VStack{
            HStack {
                Spacer()
                Text(shelfName)
                    .frame(alignment: .center)
                    .padding()
                    .foregroundColor(Color.black)
                Spacer()
            }
            .frame(width: screenWidth, height: (viewHeight * 0.075), alignment: .topLeading)
            
            
            ScrollView{
                ForEach(content, id: \.color) { element in
                    
                    HStack{
                        RoundedRectangle(cornerSize: CGSize(width: ((screenWidth * 0.08) * 0.25), height: ((screenWidth * 0.08) * 0.25)))
                            .size(width: (screenWidth * 0.08), height: (screenWidth * 0.08))
                            .fill(element.color)
                            //.frame(alignment: .init(horizontal: HorizontalAlignment.center, vertical: VerticalAlignment.top))
                            
                        Spacer().frame(width: ((screenWidth * 0.85) * 0.12))
                        Button(action: {
                            print("Book Selected!")
                            appState.bookOpen = element.bookName
                            playbackState.bookOpen = element.bookName
                            appState.screenOpen = 3
                        }, label: {Text(element.bookName)}).frame(width: ((screenWidth * 0.85) * 0.8), alignment: .leading)
                        //Spacer().frame(width: ((screenWidth * 0.85) * 0.25))
                        

                    }.frame(width: (screenWidth * 0.85), height: (screenWidth * 0.08), alignment: .topTrailing)
                        //.background(Color.red)
                }
            }
            .frame(height: (viewHeight * 0.85), alignment: .center)
            
            HStack {
                Spacer()
                Button(action: {self.libraryState.libraryBodyState = 0}, label: {Text("Back")})
                    .padding()
                Spacer()
                Button(action: {self.libraryState.libraryBodyState = 2}, label: {Text("Edit")})
                    .foregroundColor(Color.red)
                    .padding()
                Spacer()
            }
            .frame(width: screenWidth, height: (viewHeight * 0.075), alignment: .bottomTrailing)
            
            
        }.frame(width: screenWidth, height: viewHeight)
    }
    
    
}

struct ShelfElement {
    let color: Color
    let bookName: String
}

struct ShelfContents {
    let colorList = [Color(uiColor: UIColor(red: (255/255), green: (59/255), blue: (47/255), alpha: 1)), Color(uiColor: UIColor(red: (255/255), green: (149/255), blue: (28/255), alpha: 1)), Color(uiColor: UIColor(red: (255/255), green: (204/255), blue: (41/255), alpha: 1)), Color(uiColor: UIColor(red: (42/255), green: (200/255), blue: (97/255), alpha: 1)), Color(uiColor: UIColor(red: (85/255), green: (200/255), blue: (249/255), alpha: 1)), Color(uiColor: UIColor(red: (0/255), green: (122/255), blue: (252/255), alpha: 1)), Color(uiColor: UIColor(red: (87/255), green: (85/255), blue: (212/255), alpha: 1)), Color(uiColor: UIColor(red: (176/255), green: (83/255), blue: (219/255), alpha: 1)), Color(uiColor: UIColor(red: (255/255), green: (45/255), blue: (84/255), alpha: 1))]
    var bookList: [String]
    
    init(bookList: [String]) {
        self.bookList = bookList
        
    }
    
    func addElements() -> [ShelfElement]{
        var content: [ShelfElement] = []
        var count = 0
        for book in bookList {
            content.append(ShelfElement(color: colorList[count], bookName: book))
            count += 1
        }
        return content
        
    }
}



struct ShelfBodyView_Previews: PreviewProvider {
    static var previews: some View {
        ShelfBodyView()
    }
}
