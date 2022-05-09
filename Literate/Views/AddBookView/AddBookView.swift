//
//  AddBookView.swift
//  Literate
//
//  Created by Nathan Teuber on 5/9/22.
//

import SwiftUI

class AddBookState: ObservableObject {
    @Published var opperationType: Int
    
    
    init(opperationType: Int){
        self.opperationType = opperationType
    }
}

struct AddBookView: View {
    let screen = 1
    @EnvironmentObject var appState: AppState
    var body: some View {
        VStack {
            HeaderView(titleText: "AddBookScreen")
                .frame(alignment: .top)
            AddBookBodyView()
                .frame(alignment: .center)
            BottomBar(screen: screen)
                .frame(alignment: .bottom)
        }
        .frame(minWidth: 0,
            maxWidth: .infinity,
            minHeight: 0,
            maxHeight: .infinity)
        .background(Color.white)
    }

}

struct AddBookBodyView: View {
    let screenHeight = UIScreen.main.bounds.height
    let screenWidth = UIScreen.main.bounds.width
    @ObservedObject var addBookState = AddBookState(opperationType: 0)
    
    var body: some View {
        if(self.addBookState.opperationType == 1){
            AddBookCameraView()
                
        } else if(self.addBookState.opperationType == 2){
            AddBookFilesView()
            
        } else if(self.addBookState.opperationType == 3){
            AddBookPhotoLibraryView()
            
        } else {
            VStack{
                Button(action: {addBookState.opperationType = 1},
                       label: {Image(systemName: "camera");
                            Text("Take Photo")})
                Spacer()
                    .frame(height: (screenHeight * 0.05))
                Button(action: {addBookState.opperationType = 2},
                       label: {Image(systemName: "folder");
                            Text("Add Files")})
                Spacer()
                    .frame(height: (screenHeight * 0.05))
                Button(action: {addBookState.opperationType = 3},
                       label: {Image(systemName: "photo.on.rectangle.angled");
                            Text("Add From Photo Library")})
            }
            .frame(width: screenWidth,
                   height: (screenHeight * 0.8))
                
        }
        
    }
}


struct AddBookCameraView: View {
    @StateObject var c = Camera()
    let screenHeight = UIScreen.main.bounds.height
    let screenWidth = UIScreen.main.bounds.width
    
    
    var body: some View {
        HStack {
            VStack {
                
            }
            .frame(width: (screenWidth * 0.25))
            ZStack {
                CameraView(c: c)
                //Color.black
                Button(action: {}){
                    Image(systemName: "bolt.slash.fill")
                        .foregroundColor(.white)
                }
                .position(x: ((screenWidth * 0.75) - (screenWidth * 0.075)), y: (screenHeight * 0.05))
                if(c.photoTaken == true) {
                    Button(action: {
                            if(!c.photoSaved){
                                c.savePhoto()
                                c.reTakePhoto()
                            }},
                           label: {Image(systemName: "checkmark")})
                        .foregroundColor(.green)
                        .position(x: (screenWidth * 0.75)/4, y: (screenHeight * 0.725))
                        //.position(x: ((screenWidth * 0.75)/6 + 0.25), y: (screenHeight * 0.725))
                    Button(action: {c.reTakePhoto()},
                           label: {Image(systemName: "xmark")})
                        .foregroundColor(.red)
                        .padding(10)
                        .cornerRadius(0)
                        .position(x: (screenWidth * 0.75) * 0.75, y: (screenHeight * 0.725))

                } else {
                    Button(action: {c.takePhoto()}){
                        Circle()
                            .stroke(Color.white, lineWidth: 4)
                            .frame(width: (screenWidth * 0.20),
                                   height: (screenWidth * 0.20))
                            
                        
                    }
                    .position(x: ((screenWidth * 0.75)/2 + 0.25), y: (screenHeight * 0.725))
                }
            }
            
                
        }
        .frame(width: screenWidth,
               height: (screenHeight * 0.8))
        .onAppear(perform: {c.cameraPermission()})
    }
}


struct AddBookFilesView: View {
    let screenHeight = UIScreen.main.bounds.height
    let screenWidth = UIScreen.main.bounds.width
    
    var body: some View {
        HStack {
            Text("Files")
        }
        .frame(width: screenWidth,
               height: (screenHeight * 0.8))
    }
}

struct AddBookPhotoLibraryView: View {
    let screenHeight = UIScreen.main.bounds.height
    let screenWidth = UIScreen.main.bounds.width
    
    var body: some View {
        HStack {
            Text("PhotoLib")
        }
        .frame(width: screenWidth,
               height: (screenHeight * 0.8))
    }
}


struct AddBookView_Previews: PreviewProvider {
    static var previews: some View {
        AddBookView()
            .previewDevice("iPhone 12 mini")
    }
}
