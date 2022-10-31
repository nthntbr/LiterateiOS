//
//  CameraViewModel.swift
//  Literate
//
//  Created by Nathan Teuber on 5/9/22.
//

import Foundation
import AVFoundation
import SwiftUI
import UIKit

class CameraModel: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate {
    @Published var photoTaken = false
    @Published var photoSaved = false
    @Published var warning = true
    @Published var captureSession = AVCaptureSession()
    @Published var v : AVCaptureVideoPreviewLayer!
    @Published var output = AVCapturePhotoOutput()
    var photoData = Data(count: 0)
    private var photosTaken = 0
    private var context = CoreDataManager.shared.persistentContainer.viewContext
    
    
    func cameraPermission() {
        if(AVCaptureDevice.authorizationStatus(for: .video) == .authorized) {
            cameraBuild()
        } else if(AVCaptureDevice.authorizationStatus(for: .video) == .denied){
            warning.toggle()
        }else if(AVCaptureDevice.authorizationStatus(for: .video) == .notDetermined) {
            AVCaptureDevice.requestAccess(for: .video) { (permission) in
                
                if(permission){
                    self.cameraBuild()
                
                }
                
            }
            
            
        }
    }
    
    
    func cameraBuild() {
        do{
            
            self.captureSession.beginConfiguration()
            
            let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)

            let input = try AVCaptureDeviceInput(device: device!)
            
            if(self.captureSession.canAddInput(input)) {
                self.captureSession.addInput(input)
            }
            
            if(self.captureSession.canAddOutput(output)) {
                self.captureSession.addOutput(output)
                self.output.isHighResolutionCaptureEnabled = true
                self.output.maxPhotoQualityPrioritization = .quality
                
            }
            
            self.captureSession.commitConfiguration()
            
        } catch {
            print("Error Camera Not Found!")
        }
    }
    
    
    func takePhoto() {
        DispatchQueue.global(qos: .background).async {
            self.output.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
            
            DispatchQueue.main.async {
                withAnimation{self.photoTaken.toggle()}
            }
        }
        
    }
    
    
    func reTakePhoto() {
        DispatchQueue.global(qos: .background).async {
            self.captureSession.startRunning()
            DispatchQueue.main.async {
                withAnimation{self.photoTaken.toggle()}
                self.photoSaved = false

            }
        }
    }
    
    
    func savePhoto() {
        self.photosTaken += 1
        let image = UIImage(data: self.photoData)!
        
        let photo = Photo(context: self.context)
        
        photo.name = "image" + String(self.photosTaken)
        photo.image = image
        
        try? self.context.save()
        
        self.photoSaved = true
        print("Photo Sucessfully Saved!")
    }
    
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if(error == nil){
            print("Photo Taken!")
            
            guard let data = photo.fileDataRepresentation() else {return}
            self.photoData = data
            
            self.captureSession.stopRunning()
        }
        
        
    }
    
    
}











struct CameraView: UIViewRepresentable {
    
    @ObservedObject var c : CameraModel
    
    func makeUIView(context: Context) -> UIView {
        let screenHeight = UIScreen.main.bounds.height
        let screenWidth = UIScreen.main.bounds.width
        
        let view = UIView(frame: CGRect(x: 0, y: CGFloat(screenHeight * -0.0094), width: screenWidth, height: (screenHeight * 0.9)))
        
        
        c.v = AVCaptureVideoPreviewLayer(session: c.captureSession)
        c.v.frame = view.frame
        c.v.videoGravity = .resizeAspectFill
        view.layer.addSublayer(c.v)
        c.captureSession.startRunning()
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
    
}


class CaptureDeviceModel {
    var captureSession = AVCaptureSession()
    var output = AVCapturePhotoOutput()
    
    func BuildCaptureDevice() {
        captureSession.beginConfiguration()
        let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video , position: .unspecified)
        guard
            let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice!),
            captureSession.canAddInput(videoDeviceInput)
            else { return }
        captureSession.addInput(videoDeviceInput)
        
        if(self.captureSession.canAddOutput(output)) {
            self.output.isHighResolutionCaptureEnabled = true
            self.output.maxPhotoQualityPrioritization = .quality
            captureSession.sessionPreset = .photo
            captureSession.addOutput(output)
            captureSession.addOutput(output)
        }
        
        captureSession.commitConfiguration()
    }
    
}


class PreviewView: UIView {
    override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
    
    
    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
        return layer as! AVCaptureVideoPreviewLayer
    }
}
