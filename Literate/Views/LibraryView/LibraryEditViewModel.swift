//
//  LibraryEditViewModel.swift
//  Literate
//
//  Created by Nathan Teuber on 9/7/22.
//

import Foundation
import CoreData

class LibraryEditViewModel: ObservableObject {
    @Published var toDeleteList: [String]
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Book")
    private let context = CoreDataManager.shared.persistentContainer.viewContext
    
    init(toDeleteList: [String]){
        self.toDeleteList = toDeleteList
    }
    
    func deleteBooks() {
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let result = try context.fetch(fetchRequest)
            for data in result as!  [NSManagedObject] {
                for book in self.toDeleteList {
                    if(book == data.value(forKey: "name") as! String) {
                        context.delete(data)
                        
                    }
                }
                
                
            }
            try context.save()
        } catch {
            print("Error Deleting Book")
        }
    }
    
}
