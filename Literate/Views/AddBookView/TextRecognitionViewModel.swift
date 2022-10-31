//
//  ProcessBookViewModel.swift
//  Literate
//
//  Created by Nathan Teuber on 7/6/22.
//

import Vision
import Foundation
import UIKit
import CoreImage
import CoreImage.CIFilterBuiltins

class TextRecognitionViewModel {
    var image: UIImage?
    var stringList: [String]?
    //var adjustedImg: CGImage?
    
    init(image: UIImage) {
        self.image = image
        adjustAndConvertImg()
        recognizeText()
    }
    
    
    
    
    private func recognizeText(){
        guard let cgImg = self.image?.cgImage else {return}
        var requestHandler: VNImageRequestHandler
        if(cgImg.height < cgImg.width) {
            requestHandler = VNImageRequestHandler(cgImage: cgImg, orientation: CGImagePropertyOrientation.right, options: [:])
        } else {
            requestHandler = VNImageRequestHandler(cgImage: cgImg, options: [:]) //May want to change force unwrap

        }
        let request = VNRecognizeTextRequest { request, error in
            guard let observations = request.results as? [VNRecognizedTextObservation], error == nil else {return}
            let text = observations.compactMap({$0.topCandidates(1).first?.string}).joined(separator: ", ")
            print(text)
            let textList = text.components(separatedBy: ", ") //Most likely will remove the actual commas so fix in future
            self.stringList = textList
        }
        request.recognitionLevel = VNRequestTextRecognitionLevel.accurate
        request.recognitionLanguages = ["en"]
        request.usesLanguageCorrection = true
        
        do{
            print("handler")
            try requestHandler.perform([request])
            
        } catch {
            print("Failed Request! \(LocalizedError.self)")
        }
    }
    
    private func adjustAndConvertImg(){
        // turn to grayscale and invert maybe
        guard let cgImg = self.image?.cgImage else {return}
        let ciImage = CIImage(cgImage: cgImg)
        let context = CIContext()
        let filter = CIFilter(name: "CIPhotoEffectMono")!
        //filter.setValue(0.8, forKey: kCIInputIntensityKey)
        //filter.setValue(0.0, forKey: kCIInputSaturationKey)
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        let result = filter.outputImage!
        let cgImage = context.createCGImage(result, from: result.extent)!
        let uiImg = UIImage(cgImage: cgImage, scale: image!.scale, orientation: image!.imageOrientation)
        print(uiImg)
        
        self.image = uiImg
    }
    
    
    
    
    
}

/*
 This was the oridginal ocr should work and may even be better then current one, or the exact same code is just much cleaner
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
         request.recognitionLevel = VNRequestTextRecognitionLevel.accurate
         request.recognitionLanguages = ["en"]
         request.usesLanguageCorrection = true
         
         do{
             try requestHandler.perform([request])
         } catch {
             print("Failed Request! \(LocalizedError.self)")
         }
     }
     
     private func recognizeTextHandler(request: VNRequest, error: Error?) {
         guard let observations = request.results as? [VNRecognizedTextObservation] else {return}
         
         let strings = observations.compactMap { observation in
             return observation.topCandidates(1).first?.string
         }
         
         processResults(strings: strings)
             
         
     }
     
     private func processResults(strings: [String]) {
         print("Strings Processed... \(strings)")
         self.stringList = strings
         
     }
 }
 */
