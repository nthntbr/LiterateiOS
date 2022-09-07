//
//  DocumentPickerViewModel.swift
//  Literate
//
//  Created by Nathan Teuber on 5/10/22.
//

import Foundation
import SwiftUI

struct DocumentPickerViewModel: UIViewControllerRepresentable {
    
    func makeCoordinator() -> DocumentPickerViewModel.Coordinator {
        return DocumentPickerViewModel.Coordinator(dP: self)
    }
    
    func makeUIViewController(context: Context) -> some UIDocumentPickerViewController {
        let docPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.text, .pdf])
        docPicker.allowsMultipleSelection = false
        docPicker.delegate = context.coordinator
        return docPicker
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var dP: DocumentPickerViewModel
        
        init(dP: DocumentPickerViewModel) {
            self.dP = dP
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            print(urls)
            //use this to save documents
        }
    }
    
}


