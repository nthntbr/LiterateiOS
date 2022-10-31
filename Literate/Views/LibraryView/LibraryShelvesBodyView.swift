//
//  LibraryShelvesBodyView.swift
//  Literate
//
//  Created by Nathan Teuber on 10/12/22.
//

import SwiftUI

struct LibraryShelvesBodyView: View {
    @EnvironmentObject var libraryState: LibraryState
    let screenHeight = UIScreen.main.bounds.height
    let screenWidth = UIScreen.main.bounds.width
    
    var body: some View {
        let viewHeight = (screenHeight * 0.8)
        let layout = getLayout()
        let sc = ShelvesContents(shelvesList: layout)
        let content = sc.addElements()
        
        ScrollView{
            ForEach(content, id: \.color) { element in
                
                HStack{
                    RoundedRectangle(cornerSize: CGSize(width: ((screenWidth * 0.08) * 0.25), height: ((screenWidth * 0.08) * 0.25)))
                        .size(width: (screenWidth * 0.08), height: (screenWidth * 0.08))
                        .fill(element.color)
                    
                    Spacer().frame(width: ((screenWidth * 0.85) * 0.12))
                    Button(action: {
                        self.libraryState.shelfOpen = (element.shelfName, element.shelfContent)
                        self.libraryState.libraryBodyState = 1
                        
                    }, label: {Text(element.shelfName)})
                    .frame(width: ((screenWidth * 0.85) * 0.8), alignment: .leading)
                }.frame(width: (screenWidth * 0.85), height: (screenWidth * 0.08), alignment: .topTrailing)
            }
        }.frame(height: (viewHeight * 0.85), alignment: .center)
    }
    
    func getLayout() -> [(String, [String])] {
        let LM = LibraryModel()
        return LM.selectLayout()
    }
}

struct ShelvesElement {
    let color: Color
    let shelfName: String
    let shelfContent: [String]
}

struct ShelvesContents {
    let colorList = [Color(uiColor: UIColor(red: (255/255), green: (59/255), blue: (47/255), alpha: 1)), Color(uiColor: UIColor(red: (255/255), green: (149/255), blue: (28/255), alpha: 1)), Color(uiColor: UIColor(red: (255/255), green: (204/255), blue: (41/255), alpha: 1)), Color(uiColor: UIColor(red: (42/255), green: (200/255), blue: (97/255), alpha: 1)), Color(uiColor: UIColor(red: (85/255), green: (200/255), blue: (249/255), alpha: 1)), Color(uiColor: UIColor(red: (0/255), green: (122/255), blue: (252/255), alpha: 1)), Color(uiColor: UIColor(red: (87/255), green: (85/255), blue: (212/255), alpha: 1)), Color(uiColor: UIColor(red: (176/255), green: (83/255), blue: (219/255), alpha: 1)), Color(uiColor: UIColor(red: (255/255), green: (45/255), blue: (84/255), alpha: 1))]
    var shelvesList: [(String, [String])]
    
    init(shelvesList: [(String, [String])]) {
        self.shelvesList = shelvesList
        
    }
    
    func addElements() -> [ShelvesElement]{
        var content: [ShelvesElement] = []
        var count = 0
        for shelf in shelvesList {
            content.append(ShelvesElement(color: colorList[count], shelfName: shelf.0, shelfContent: shelf.1))
            count += 1
        }
        return content
        
    }
}

struct LibraryShelvesBodyView_Previews: PreviewProvider {
    static var previews: some View {
        LibraryShelvesBodyView()
    }
}
