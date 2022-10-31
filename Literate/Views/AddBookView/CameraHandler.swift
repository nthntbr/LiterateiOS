//
//  CameraHandler.swift
//  Literate
//
//  Created by Nathan Teuber on 10/18/22.
//

import AVFoundation
import CoreImage
//import os.log
import UIKit
import SwiftUI


class CameraHandler: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate {
    @Published var frame: CGImage?
    @Published var photoTaken: CGImage?
    @Published var isFlash: Bool
    let videoCaptureSession = AVCaptureSession()
    let captureSession = AVCaptureSession()
    let videoCaptureSessionQueue = DispatchQueue(label: "cameraSessionQueue")
    let captureSessionQueue = DispatchQueue(label: "captureSessionQueue")
    let context = CIContext()
    private var coreDataContext = CoreDataManager.shared.persistentContainer.viewContext
    var deviceInput: AVCaptureDeviceInput?
    var photoOutput = AVCapturePhotoOutput()
    var isAuthorized: Bool
    
    
    init(isAuthorized: Bool, isFlash: Bool){
        self.isAuthorized = isAuthorized
        self.isFlash = isFlash
        super.init()
        self.checkPremission()
        
        
    }
        
    func checkPremission() {
        if(!self.isAuthorized) {
            switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized: // The user has previously granted access to the camera.
                self.isAuthorized = true;
                self.videoCaptureSessionQueue.async { [unowned self] in
                    self.setupCaptureSession()
                    self.videoCaptureSession.startRunning()
                }
                
                
            case .notDetermined: // The user has not yet been asked for camera access.
                AVCaptureDevice.requestAccess(for: .video) { granted in
                    if granted {
                        self.isAuthorized = true;
                        self.videoCaptureSessionQueue.async { [unowned self] in
                            self.setupCaptureSession()
                            self.videoCaptureSession.startRunning()
                        }
                    }
                }
                
            case .denied: // The user has previously denied access.
                return
                
            case .restricted: // The user can't grant access due to restrictions.
                return
            @unknown default:
                fatalError()
            }
        } else {
            self.videoCaptureSessionQueue.async { [unowned self] in
                self.setupCaptureSession()
                self.videoCaptureSession.startRunning()
            }
        }
    }
    
    func setupCaptureSession() {
        let videoOutput = AVCaptureVideoDataOutput()
        guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {return}
        guard let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice) else {return}
        guard videoCaptureSession.canAddInput(videoDeviceInput) else {return}
        videoCaptureSession.addInput(videoDeviceInput)
        
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "sampleBufferQueue"))
        videoCaptureSession.addOutput(videoOutput)
        videoOutput.connection(with: .video)?.videoOrientation = .portrait
        
    }
    
//Clean up code below
    
    
    func takePhoto() {
        
        captureSessionQueue.async {
        
            do{
                self.captureSession.beginConfiguration()
                
                let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)

                let input = try AVCaptureDeviceInput(device: device!)
                
                if(self.captureSession.canAddInput(input)) {
                    self.captureSession.addInput(input)
                }
                
                if(self.captureSession.canAddOutput(self.photoOutput)) {
                    self.captureSession.addOutput(self.photoOutput)
                    self.photoOutput.isHighResolutionCaptureEnabled = true
                    self.photoOutput.maxPhotoQualityPrioritization = .quality
                    
                }
                
                self.captureSession.commitConfiguration()
                
            } catch {
                print("Error Camera Not Found!")
            }
            
            self.videoCaptureSession.stopRunning()
            self.captureSession.startRunning()
            
            var photoSettings = AVCapturePhotoSettings()
            if(self.photoOutput.availablePhotoCodecTypes.contains(.hevc)) {
               photoSettings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.hevc])
            }
            
            if(self.isFlash) {
                let isFlashAvailable = self.deviceInput?.device.isFlashAvailable ?? false
                photoSettings.flashMode = isFlashAvailable ? .auto : .on
            }
            
            // write if statement for user's choice and if on run these lines
            //let isFlashAvailable = self.deviceInput?.device.isFlashAvailable ?? false
            //photoSettings.flashMode = isFlashAvailable ? .auto : .off
            
            
            //photoSettings.maxPhotoDimensions =
            
            
            
            self.photoOutput.capturePhoto(with: photoSettings, delegate: self)
        }
        
    }
    
    func savePhoto() -> Bool {
        if(photoTaken != nil) {
            let date = Date()
            let nameSig = date.timeIntervalSince1970
            
            let image = UIImage(cgImage: photoTaken!)
            
            let photo = Photo(context: self.coreDataContext)
            var name = "image" + String(nameSig)
            name.remove(at: name.firstIndex(of: String.Element("."))!)
            print(name)
            photo.name = "image" + String()
            photo.image = image
            
            try? self.coreDataContext.save()
            
            //self.photoSaved = true
            print("Photo Sucessfully Saved!")
            self.photoTaken = nil
            return true
        } else {
            return false
        }
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if(error == nil){
            
            self.captureSession.stopRunning()
            var ciImg = CIImage()
            let photoData = photo.fileDataRepresentation()
            let testCIImg = CIImage(data: photoData!) ?? nil
            
            if(testCIImg != nil) {
                ciImg = testCIImg!
                print("photoData Not Nil")
            }
            
            ciImg = ciImg.oriented(CGImagePropertyOrientation.right)
            let cgImg = CIContext().createCGImage(ciImg, from: ciImg.extent)
            
            self.photoTaken = cgImg
            print("Photo Taken!")
        } else {
            print(error!)
        }
        
        
        
    }
    
}

extension CameraHandler: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let cgImg = frameFromSampleBuffer(sampleBuffer: sampleBuffer) else {return}
        DispatchQueue.main.async { [self] in
            self.frame = cgImg
            
        }
    }
    
    private func frameFromSampleBuffer(sampleBuffer: CMSampleBuffer) -> CGImage? {
        guard let buffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {return nil}
        let ciImg = CIImage(cvPixelBuffer: buffer)
        guard let cgImg = context.createCGImage(ciImg, from: ciImg.extent) else {return nil}
        return cgImg
    }
}

