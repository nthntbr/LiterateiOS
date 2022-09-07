//
//  FinalizeBookViewModel.swift
//  Literate
//
//  Created by Nathan Teuber on 8/30/22.
//

import Foundation
import UIKit


class FinalizeBookViewModel {
    var photoData: PhotoViewModel
    var bookName: String
    var photoList: [(name: String, image: UIImage)]
    private var context = CoreDataManager.shared.persistentContainer.viewContext
    
    init(bookName: String) {
        self.bookName = bookName
        self.photoData = PhotoViewModel()
        self.photoList = self.photoData.photoList
        
        
    }
    
    func finalizeBook() {
        var pageDict: [Int: [String]] = [:]
        var stringList: [String]
        var count = 0
        
        for photo in photoList {
            let trvm = TextRecognitionViewModel(image: photo.image)
            stringList = trvm.stringList ?? ["Error No Strings Found On Page!"]
            pageDict.updateValue(stringList, forKey: count)

            count += 1
        }
        
        saveBook(pages: pageDict)
        
        
        
        
    }
    
    private func saveBook(pages: [Int: [String]]) {
        
        let bk = Book(context: self.context)
        bk.pages = pages as NSDictionary
        bk.name = self.bookName
        
        try? self.context.save()
        print("Book Sucessfully Saved!")
        
    }
    
    
        
    
    
    
}
