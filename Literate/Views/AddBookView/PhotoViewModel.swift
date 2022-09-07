//
//  PhotoViewModel.swift
//  Literate
//
//  Created by Nathan Teuber on 5/9/22.
//

import Foundation
import SwiftUI
import CoreData

class PhotoViewModel: ObservableObject {
    @Published var photoList: [(name: String, image: UIImage)]
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Photo")
    private let context = CoreDataManager.shared.persistentContainer.viewContext
    
    init(){
        fetchRequest.returnsObjectsAsFaults = false
        var imgList = [(String, UIImage)]()
        do {
            let result = try context.fetch(fetchRequest)
            for data in result as! [NSManagedObject] {
                let img = data.value(forKey: "image") as! UIImage
                let name = data.value(forKey: "name") as! String
                let image = (name, img)
                imgList.append(image)
            }
        } catch {
            print("Error With PhotoData")
        }
        
        self.photoList = imgList
        
    }
    
    init(photoList: [(name: String, image: UIImage)]) {
        self.photoList = photoList
    }
    
    func removePhoto(photoToDelete: String) {
        print("Bug:1 Loaction: ", self.photoList)
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let result = try context.fetch(fetchRequest)
            for data in result as!  [NSManagedObject] {
                if(photoToDelete == data.value(forKey: "name") as! String) {
                    context.delete(data)
                    
                }
            }
            try context.save()
        } catch {
            print("Error Deleting Photo")
        }
        var i = 0
        for photo in photoList {
            if(photoToDelete == photo.name) {
                // Bug:1 location
                self.photoList.remove(at: i)
            }
            i += 1
        }
        
    }
}

struct PhotoView: View {
    @ObservedObject var photoData = PhotoViewModel()
    let screenHeight = UIScreen.main.bounds.height
    let screenWidth = UIScreen.main.bounds.width
    
    var body: some View {
        let photos = photoData.photoList
        ForEach(photos, id: \.name) { photoTuple in
            let photo = photoTuple.image
            let scale = (screenWidth * 0.225) / photo.size.width
            let height = scale * photo.size.height
            Image(uiImage: photo)
                .resizable()
                .frame(width: (screenWidth * 0.225), height: height)
                .padding()
            Button(action: {photoData.removePhoto(photoToDelete: photoTuple.name)
                
            }, label: {Text("Remove")})
           
            
        }
         
    
    }
    
}


