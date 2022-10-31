//
//  LibraryModel.swift
//  Literate
//
//  Created by Nathan Teuber on 9/2/22.
//

import Foundation
import CoreData

class LibraryModel {
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Book")
    private let context = CoreDataManager.shared.persistentContainer.viewContext
    var bookNameList: [String] {
        fetchRequest.returnsObjectsAsFaults = false
        var list: [String] = []
        do {
            let result = try context.fetch(fetchRequest)
            
            for data in result as! [NSManagedObject] {
                let bookName = data.value(forKey: "name") as! String
                list.append(bookName)
            }
        } catch {
            print("Error Retriving Book List")
        }
        return list
    }
    
    var userStoredLayout: [(String, [String])] = []// In future use for user stored layout
    
    init() {
        
        
    }
    
    func selectLayout() -> [(String, [String])] {
        if (self.userStoredLayout.isEmpty != true) {
            return self.userStoredLayout
        } else {
            var layout: [(String, [String])] = []
            layout.append(("All Books", self.bookNameList))
            return layout
        }
            
    }
}
