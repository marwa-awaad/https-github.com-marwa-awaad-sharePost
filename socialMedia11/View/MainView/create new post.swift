//
//  create new post.swift
//  socialMedia11
//
//  Created by marwa awwad mohamed awwad on 12.07.2023.
//

import SwiftUI
import PhotosUI
import Firebase
import FirebaseStorage
import FirebaseFirestore



struct create_new_post: View {
    var onPost: (Post )-> ()
    //post properties
    @State private var postText: String =  ""
    @State private var postImageData: Data?
    
    
    @AppStorage("user_profile_url") private var profileURL: URL?
    @AppStorage("user_name") private var userName: String = ""
    @AppStorage("user_uid") private var userUID: String = ""
    
    @Environment(\.dismiss) private var dismiss
    @State private var isLoading: Bool = false
    @State private var errorMessage: String = ""
    @State private var showError: Bool = false
    @State private var showImagePicker: Bool = false
    @State private var  photoItem: PhotosPickerItem?
    @FocusState private var showKeyBoard: Bool
    var body: some View{
        VStack{
            HStack{
                Menu{
                    Button("Cancle",role: .destructive ){
                        dismiss()
                    }
                    
                }label: {
                    Text("Cancel")
                        .foregroundColor(.black)
                                       }
                .hAlign(.leading )
                Button(action: CreatePost){
                     Text("Post ")
                        .font( .callout )
                        .foregroundColor(.white)
                        .padding(.horizontal,20)
                        .padding(.vertical,6 )
                        .background(.black,in:Capsule() )
                    
                    
                        
                }
                .disableWithOpacity(postText == "")
            }
            .padding( .horizontal,15)
            .padding(.vertical, 10)
            .background{
                Rectangle()
                    .fill(.gray.opacity(0.05))
                    .ignoresSafeArea()
            }
            ScrollView(.vertical,showsIndicators: false){
                VStack(spacing: 15){
                    TextField("what's happening ",text: $postText,axis: .vertical)
                        .focused($showKeyBoard)
                    if let postImageData,let image = UIImage(data: postImageData){
                        GeometryReader{
                            let size = $0.size
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(  contentMode: .fill)
                                .frame(width: size.width,height: size.height)
                                .clipShape(RoundedRectangle(cornerRadius: 10,style: .continuous))
                            //delete button
                                .overlay(alignment:.topTrailing){
                                    Button{
                                        withAnimation(.easeInOut(duration: 0.25)){
                                            self.postImageData = nil
                                        }
                                    }label: {
                                        Image(systemName:  "trash")
                                            .fontWeight(.bold)
                                            .tint(.red)
                                    }
                                    .padding(10 )
                                }
                        }
                        .clipped()
                        .frame(height: 220 )
                    }
                }
                .padding(15)
            }
            Divider()
            
            HStack{
                Button{
                    showImagePicker.toggle()
                }label: {
                    Image(systemName: "photo.on.rectangle")
                        .font(.title3)
                }
                .hAlign(.leading )
                
                Button("Done "){
                    showKeyBoard = false
                }
            }
            .foregroundColor(.black ) 
            .padding( .horizontal,15)
            .padding( .vertical ,10 )
        }
        .vAlign( .top)
        .photosPicker(isPresented: $showImagePicker, selection: $photoItem)
        .onChange(of: photoItem){ newValue in
            if let newValue{
                Task{
                    if let rawImageData = try? await newValue.loadTransferable(type: Data.self),let image =  UIImage(data: rawImageData), let compressedImageData = image.jpegData(compressionQuality:   0.5){
                        //UI must be done in main thread
                        await MainActor.run(body: {
                            postImageData = compressedImageData
                            photoItem = nil
                        })
                    }
                }
                
            }
                //.alert( errorMessage , isPresented: $showError, actions: {} })
                
    }
        
        //post content to fire base
        func CreatePost(){
             isLoading = true
            showKeyBoard = false
            Task{
                do {
                    guard let profileURL = profileURL else{return}
                    //1-uploading image if any
                    let imageRefrenceId = "\(userUID)\(Date)"
                    let storageRef = Storage.storage().reference().child("post_Images").child(imageRefrenceId)
                    if let postImageData{
                        let _ = try await storageRef.putData( postImageData)
                        let downloadURL = try await storageRef.downloadURL()
                        //create post object with image id and url
                    let post = Post(text: postText, userName: userName, userUID: userUID, userProfIleURL: profileURL)
                                  try await createDocumentAtFireBase(Post)
                        
                    } else{
                        let post = Post(text: postText, userName: userName, userUID: userUID, userProfIleURL:profileURL )
                        try await createDocumentAtFireBase(post)
                        }
                }catch{
                    await setError(error )
                }
            }
            
            
        }
    func createDocumentAtFireBase(_ Post: Post)async throws{
                        //writing document to firebase fireStore
                        let _ = try  Firestore.firestore().collection("Posts").addDocument(from: Post,completion: {
                            error in
                            if error == nil {
                                //post stored in fire base
                                isLoading = false
                                onPost(Post)
                                dismiss
                              
                        }
                        }  )
        
    }
    
     
        //displaying errors as alerts
        func setError(_ error: Error )async {
            await MainActor.run(body: {
                errorMessage = error.localizedDescription
                showError.toggle()
            })
        }
                                    }
                                    }
struct create_new_post_Previews: PreviewProvider {
    static var previews: some View {
        create_new_post{
            _ in
        }
    }
}
                                    
                        
