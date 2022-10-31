//
//  CameraPreviewView.swift
//  Literate
//
//  Created by Nathan Teuber on 10/7/22.
//

import SwiftUI

struct CameraPreviewView: View {
    var image: CGImage?
    let screenHeight = UIScreen.main.bounds.height
    let screenWidth = UIScreen.main.bounds.width
    let label = Text("frame")
    
    var body: some View {
        if let image = image {
            Image(image, scale: 1, orientation: .up, label: label)
                .resizable()
                .frame(width: screenWidth)
        } else {
            Color.black
        }
    }
}

struct CameraContentView: View {
    @EnvironmentObject var addBookState: AddBookState
    @StateObject var model = CameraHandler(isAuthorized: false, isFlash: false)
    @State var isPhotoTaken = false
    let screenHeight = UIScreen.main.bounds.height
    let screenWidth = UIScreen.main.bounds.width
    
    
    var body: some View {
        if(isPhotoTaken) {
            ZStack {
                if(model.photoTaken != nil) {
                    Image(model.photoTaken!, scale: 1, orientation: .up, label: Text("frame"))
                        .resizable()
                        .frame(width: screenWidth)
                        
                } else {
                    Color.black
                }
                HStack {
                    //Crop Button
                    Spacer()
                    Button(action: {}, label: {Image(systemName: "crop").foregroundColor(Color.white)})
                    Spacer()
                    Button(action: {
                        let isSaved = model.savePhoto()
                        if(isSaved){
                            isPhotoTaken = false
                            model.photoTaken = nil
                            model.checkPremission()
                        }
                    },
                           label: {Image(systemName: "checkmark")})
                        .foregroundColor(.green)
                        
                    Spacer()
                    Button(action: {
                        isPhotoTaken = false
                        model.photoTaken = nil
                        model.checkPremission()
                    },
                           label: {Image(systemName: "xmark")})
                        .foregroundColor(.red)
                    
                    Spacer()
                    
                }
                .frame(width: screenWidth, height: (screenHeight * 0.05), alignment: .center)
                .background(Color.blue)
                .position(x: (screenWidth * 0.5), y: (screenHeight * 0.8625))
                
                
                
            
            
            }.frame(height: (screenHeight * 0.9), alignment: .bottom)
                
        } else {
            ZStack{
                CameraPreviewView(image: model.frame)
                    .ignoresSafeArea()
                
                Button(action: {
                    model.takePhoto()
                    isPhotoTaken = true
                }){
                    Circle()
                        .stroke(Color.white, lineWidth: 4)
                        .frame(width: (screenWidth * 0.20),
                               height: (screenWidth * 0.20))
                }
                .position(x: (screenWidth / 2), y: (screenHeight * 0.775))
                
                Button(action: {addBookState.opperationType = 4}){
                    ZStack {
                        Capsule()
                            .fill(Color.blue)
                            .frame(width: (screenWidth * 0.225), height: (screenWidth * 0.125))
                        Text("Add Book")
                            .foregroundColor(Color.white)
                            .frame(width: (screenWidth * 0.2))
                                            
                    }
                    
                    
                }
                .position(x: (screenWidth * 0.825), y: (screenHeight * 0.775))
                
                Button(action: {
                    model.isFlash = !model.isFlash
                    model.checkPremission()
                }){
                    if(model.isFlash == true) {
                        Image(systemName: "bolt.fill")
                            .foregroundColor(.white)
                    } else {
                        Image(systemName: "bolt.slash.fill")
                            .foregroundColor(.white)
                    }
                }
                .zIndex(1)
                .position(x: (screenWidth * 0.925), y: (screenHeight * 0.1))


            }
        }
        
            
        
        
        
    }
}

struct CameraPreviewView_Previews: PreviewProvider {
    static var previews: some View {
        CameraPreviewView()
    }
}
