//
//  Book.swift
//  Literate
//
//  Created by Nathan Teuber on 9/1/22.
//

import Foundation
import CoreData


@objc(Book)
class Book: NSManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Book> {
        return NSFetchRequest<Book>(entityName: "Book")
    }

    @NSManaged public var pages: NSDictionary?
    @NSManaged public var name: String?

}

extension Book : Identifiable {

}
