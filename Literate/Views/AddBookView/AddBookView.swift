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
    let screenHeight = UIScreen.main.bounds.height
    let screenWidth = UIScreen.main.bounds.width
    let screen = 1
    @EnvironmentObject var appState: AppState
    var body: some View {
        ZStack {
            //Copy for other pages
            HeaderView(titleText: "AddBookScreen")
                .frame(alignment: .top)
                .position(x: (screenWidth/2), y: (screenHeight * 0.02))
                .zIndex(1)
            AddBookBodyView()
                .frame(alignment: .center)
                .position(x: (screenWidth/2), y: (screenHeight * 0.425))
            BottomBar(screen: screen)
                .frame(alignment: .bottom)
                .position(x: (screenWidth/2), y: (screenHeight * 0.8875))
                .zIndex(1)
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
    @State var showDP = false
    @State var showPP = false
    
    
    var body: some View {
        // Maybe change if for a switch statement with enumeration
        if(self.addBookState.opperationType == 1){
            //AddBookCameraView()
                //.environmentObject(addBookState)
            CameraContentView()
                .environmentObject(addBookState)
                
        } else if(self.addBookState.opperationType == 2){ // Not reached currently
            AddBookFilesView()
                .environmentObject(addBookState)
            
        } else if(self.addBookState.opperationType == 3){
            AddBookPhotoLibraryView()
                .environmentObject(addBookState)
            
            
        } else if(self.addBookState.opperationType == 4) {
            FinalizeBookView()
                .environmentObject(addBookState)
        }else {
            VStack{
                Button(action: {addBookState.opperationType = 1},
                       label: {Image(systemName: "camera");
                            Text("Take Photo")})
                Spacer()
                    .frame(height: (screenHeight * 0.05))
                Button(action: {
                    self.showDP.toggle()
                }, label: {Image(systemName: "folder");
                    Text("Add Files")})
                .sheet(isPresented: $showDP) {
                    DocumentPickerViewModel()
                }
                Spacer()
                    .frame(height: (screenHeight * 0.05))
                Button(action: {
                    addBookState.opperationType = 3
                }, label: {Image(systemName: "photo.on.rectangle.angled");
                    Text("Add From Photo Library")})
            }
            .frame(width: screenWidth,
                   height: (screenHeight * 0.8))
                
        }
        
    }
}

//Deprecated
struct AddBookCameraView: View {
    @StateObject var c = CameraModel()
    @EnvironmentObject var addBookState: AddBookState
    let screenHeight = UIScreen.main.bounds.height
    let screenWidth = UIScreen.main.bounds.width
    
    
    var body: some View {
        ZStack {
            CameraView(c: c)
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
            .position(x: (screenWidth * 0.825), y: (screenHeight * 0.725))
        if(c.photoTaken == true) {
            ScrollView {
                PhotoView()
            }
            .frame(width: (screenWidth * 0.25), height: (screenHeight * 0.9), alignment: .top)
            .background(Color.gray)
            .position(x: (screenWidth * 0.25)/2, y: ((screenHeight * 0.8)/2))
            .opacity(0.85)

            Button(action: {
                    if(!c.photoSaved){
                        c.savePhoto()
                        c.reTakePhoto()
                    }},
                   label: {Image(systemName: "checkmark")})
                .foregroundColor(.green)
                .position(x: (screenWidth / 2), y: (screenHeight * 0.725))
            Button(action: {c.reTakePhoto()},
                   label: {Image(systemName: "xmark")})
                .foregroundColor(.red)
                .position(x: (screenWidth - (screenWidth * 0.075)), y: (screenHeight * 0.05))
        } else {
                Button(action: {}){
                    Image(systemName: "bolt.slash.fill")
                        .foregroundColor(.white)
                }
                .position(x: (screenWidth - (screenWidth * 0.075)), y: (screenHeight * 0.05))
                Button(action: {c.takePhoto()}){
                    Circle()
                        .stroke(Color.white, lineWidth: 4)
                        .frame(width: (screenWidth * 0.20),
                               height: (screenWidth * 0.20))
                }
                .position(x: (screenWidth / 2), y: (screenHeight * 0.725))
                
            
        }
        }
        .frame(width: screenWidth,
               height: (screenHeight * 0.8))
        .onAppear(perform: {c.cameraPermission()})
        
        
    }
}


struct AddBookFilesView: View { // not used currently
    @EnvironmentObject var addBookState: AddBookState
    @State var show = false
    let screenHeight = UIScreen.main.bounds.height
    let screenWidth = UIScreen.main.bounds.width
    
    var body: some View {
        HStack {
            Button(action: {
                self.show.toggle()
            }, label: {Text("File Picker")})
            .sheet(isPresented: $show) {
                DocumentPickerViewModel()
            }
        }
        .frame(width: screenWidth,
               height: (screenHeight * 0.8))
    }
}

struct AddBookPhotoLibraryView: View {
    @EnvironmentObject var addBookState: AddBookState
    @State private var show = true
    @State private var imgsSelected = [(name: String, image: UIImage)]()
    let screenHeight = UIScreen.main.bounds.height
    let screenWidth = UIScreen.main.bounds.width
    private var context = CoreDataManager.shared.persistentContainer.viewContext
    
    var body: some View {
        
        VStack {
            ScrollView {
                if imgView() != nil {
                    imgView()
                }
                
            }
            
            
            
            HStack{
                Button(action: {
                self.show.toggle()
                }, label: {Text("File Picker")})
            .sheet(isPresented: $show) {
                PhotoPickerViewModel(imgsSelected: $imgsSelected, isShown: $show)
            }
            
            Button(action: {
                savePhoto()
                addBookState.opperationType = 4
            }, label: {Text("Finalize Book")})
                .frame(height: (screenHeight * 0.8) * 0.15)
                
            }
        }
        .frame(width: screenWidth,
               height: (screenHeight * 0.8))
    }
    
    
    func imgView() -> PhotoView? {
        if self.imgsSelected.count > 0 {
            let photoData = PhotoViewModel(photoList: imgsSelected)
            return PhotoView(photoData: photoData)
        } else {
            return nil
        }
    }
    
    func savePhoto() {
        for photo in $imgsSelected {
            let p = Photo(context: context)
            p.name = photo.wrappedValue.name
            p.image = photo.wrappedValue.image
            try? self.context.save()
            print("Photo Sucessfully Saved!")
        }
        
        
    }
    
}

struct FinalizeBookView: View {
    @EnvironmentObject var addBookState: AddBookState
    @State private var bookName = "Book"
    let screenHeight = UIScreen.main.bounds.height
    let screenWidth = UIScreen.main.bounds.width
    
    var body: some View {
        VStack {
            ScrollView {
                PhotoView()
            }
            .frame(height: (screenHeight * 0.8) * 0.85)
            TextField("Enter Book Name", text: $bookName)
                .foregroundColor(Color.black)
            HStack {
                Button(action: {}){
                    ZStack {
                        Capsule()
                            .frame(width: (screenWidth * 0.3), height: (screenWidth * 0.15))
                        Text("Cancel")
                            .frame(width: (screenWidth * 0.25))
                            .foregroundColor(Color.white)
                    }
                }
                .padding()
                Button(action: {
                    let fbvm = FinalizeBookViewModel(bookName: bookName)
                    fbvm.finalizeBook()
                    
                }){
                    ZStack {
                        Capsule()
                            .frame(width: (screenWidth * 0.3), height: (screenWidth * 0.15))
                        Text("Add Book")
                            .frame(width: (screenWidth * 0.25))
                            .foregroundColor(Color.white)
                    }
                }
                .padding()
            }
            .frame(height: (screenHeight * 0.8) * 0.15)
            
        }
        .frame(height: (screenHeight * 0.8))
        
        
    }
}


struct AddBookView_Previews: PreviewProvider {
    static var previews: some View {
        AddBookView()
            .previewDevice("iPhone 13")
    }
}
