//
//  Photo.swift
//  Literate
//
//  Created by Nathan Teuber on 5/9/22.
//

import Foundation
import CoreData
import UIKit


@objc(Photo)
class Photo: NSManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo")
    }

    @NSManaged public var image: UIImage?
    @NSManaged public var name: String?

}

extension Photo : Identifiable {

}
