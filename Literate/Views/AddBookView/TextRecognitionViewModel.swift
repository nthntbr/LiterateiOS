//
//  ProcessBookViewModel.swift
//  Literate
//
//  Created by Nathan Teuber on 7/6/22.
//

import Vision
import Foundation
import UIKit

class TextRecognitionViewModel {
    var image: UIImage?
    var stringList: [String]?
    
    init(image: UIImage) {
        self.image = image
        recognizeText()
    }
    
    
    
    
    private func recognizeText(){
        guard let cgImg = self.image?.cgImage else {return}
        let requestHandler = VNImageRequestHandler(cgImage: cgImg)
        let request = VNRecognizeTextRequest(completionHandler: recognizeTextHandler)
            
        
        do{
            try requestHandler.perform([request])
        } catch {
            print("Failed Request! \(LocalizedError.self)")
        }
    }
    
    private func recognizeTextHandler(request: VNRequest, error: Error?) {
        guard let observations = request.results as? [VNRecognizedTextObservation] else {return}
        
        let strings = observations.compactMap { observations in
            return observations.topCandidates(1).first?.string
        }
        
        processResults(strings: strings)
            
        
    }
    
    private func processResults(strings: [String]) {
        print("Strings Processed... \(strings)")
        self.stringList = strings
        
    }
}

