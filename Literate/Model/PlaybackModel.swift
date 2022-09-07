//
//  PlaybackModel.swift
//  Literate
//
//  Created by Nathan Teuber on 9/6/22.
//

import Foundation
import CoreData

class PlaybackModel {
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Book")
    private let context = CoreDataManager.shared.persistentContainer.viewContext
    var bookOpen: String
    var book: (String, [Int: [String]]) {
        var book = ("*BookName*", [0 : ["Error Loading Book"]])
        do {
            let result = try context.fetch(fetchRequest)
            
            for data in result as! [NSManagedObject] {
                let bookName = data.value(forKey: "name") as! String
                if(self.bookOpen == bookName) {
                    let pages = data.value(forKey: "pages") as! [Int: [String]]
                    book = (bookName, pages)
                    print("Success Finding Book!")
                }
            }
        } catch {
            print("Error Retriving Book")
        }
        return book
    }
    
    init(bookOpen: String) {
        self.bookOpen = bookOpen
        
        
    }
    
    
    
    
}
