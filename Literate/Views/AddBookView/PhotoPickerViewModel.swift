//
//  PhotoPickerViewModel.swift
//  Literate
//
//  Created by Nathan Teuber on 5/16/22.
//

import Foundation
import SwiftUI
import PhotosUI

struct PhotoPickerViewModel: UIViewControllerRepresentable {
    @Binding var imgsSelected: [(name: String, image: UIImage)]
    @Binding var isShown: Bool
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var pickerConfig = PHPickerConfiguration()
        pickerConfig.filter = .images
        pickerConfig.selectionLimit = 0
        let photoPicker = PHPickerViewController(configuration: pickerConfig)
        photoPicker.delegate = context.coordinator
        return photoPicker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: PhotoPickerViewModel
        
        init(_ parent: PhotoPickerViewModel){
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true, completion: nil)
            guard !results.isEmpty else {return}
            var count = 0
            for result in results {
                if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                    result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                        if let error = error {
                            print("Error Failed Loading Image! \(error.localizedDescription)")
                        } else if let result = image as? UIImage {
                            let name = "Page\(count + 1)"
                            count += 1
                            let photoTuple = (name, result)
                            self?.parent.imgsSelected.append(photoTuple)
                        }
                        
                    }
                } else {
                    print("Failed Loading Result!")
                }
                
                
            }
            
            self.parent.isShown = false
            
        }
    }
}
