//
//  LibraryEditView.swift
//  Literate
//
//  Created by Nathan Teuber on 9/6/22.
//

import Foundation
import SwiftUI

struct LibraryEditView: View {
    @EnvironmentObject var libraryState: LibraryState
    @EnvironmentObject var appState: AppState
    @ObservedObject var levm = LibraryEditViewModel(toDeleteList: [])

    
    let screenHeight = UIScreen.main.bounds.height
    let screenWidth = UIScreen.main.bounds.width
    let colorList: [Color] = [Color.blue, Color.green, Color.indigo, Color.mint, Color.orange, Color.pink, Color.purple, Color.red, Color.teal, Color.yellow]
    
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
                    let isSelected = self.levm.toDeleteList.contains(element.bookName)
                    HStack{
                        RoundedRectangle(cornerSize: CGSize(width: ((screenWidth * 0.08) * 0.25), height: ((screenWidth * 0.08) * 0.25)))
                            .size(width: (screenWidth * 0.08), height: (screenWidth * 0.08))
                            .fill(element.color)
                            //.frame(alignment: .init(horizontal: HorizontalAlignment.center, vertical: VerticalAlignment.top))
                            
                        Spacer().frame(width: ((screenWidth * 0.85) * 0.12))
                        Button(action: {
                            print("Book Selected!")
                            if(isSelected) {
                                var index = -1
                                var count = 0
                                for b in self.levm.toDeleteList {
                                    if(b == element.bookName) {
                                        index = count
                                    }
                                    count += 1
                                }
                                if(index > -1) {
                                    self.levm.toDeleteList.remove(at: index)
                                } else {
                                    print("Error Deselecting Book")
                                }
                                
                            } else {
                                self.levm.toDeleteList.append(element.bookName)
                            }
                            
                            
                        }, label: {
                            if(isSelected){
                                Text(element.bookName)
                                    .foregroundColor(Color.white)
                                    .background(Color.blue)
                            } else {
                                Text(element.bookName)
                                    .foregroundColor(Color.blue)
                            }
                            
                        }).frame(width: ((screenWidth * 0.85) * 0.8), alignment: .leading)
                        
                    }.frame(width: (screenWidth * 0.85), height: (screenWidth * 0.08), alignment: .topTrailing)
                }
            }
            .frame(height: (viewHeight * 0.85), alignment: .center)
            
            HStack {
                Spacer()
                Button(action: {self.libraryState.libraryBodyState = 0}, label: {Text("Back")})
                    .padding()
                Spacer()
                Button(action: {
                    self.levm.deleteBooks()
                    self.libraryState.refreshShelf()
                    self.libraryState.libraryBodyState = 1
                }, label: {Image(systemName: "trash").foregroundColor(Color.red)})
                    .padding()
                Spacer()
            }
            .frame(width: screenWidth, height: (viewHeight * 0.075), alignment: .bottomTrailing)
        }
    }
    
    
}
