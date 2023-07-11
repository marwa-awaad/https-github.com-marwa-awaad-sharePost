//
//  RegisterationView.swift
//  socialMedia11
//
//  Created by marwa awwad mohamed awwad on 11.07.2023.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import PhotosUI

// Register view

struct RegisterView: View{
    
    @State var emailID: String = ""
    @State var password: String = ""
    @State var userName: String = ""
    @State var userBio: String = ""
    @State var userBioLink: String = ""
    @State var userProfilePicData: Data?
    //view properties
    @Environment(\.dismiss) var dismiss
    @State var showImagePicker: Bool = false
    @State var photoItem: PhotosPickerItem?
    @State var showError: Bool = false
    @State var errorMessage: String = ""
    @State var isLoading: Bool = false
    //user defalts
    @AppStorage ("log_status") var logStatus:Bool = false
    @AppStorage("user_profile_url") var profieURL:URL?
    @AppStorage("user_name") var userNameStored: String = ""
    @AppStorage("user_UID") var userUID: String = ""
    
    var body: some View{
        VStack(spacing: 10  ){
            Text ("Let's Regstir \n new account")
                .font (.largeTitle.bold ())
                .hAlign(.leading )
            
            
            Text(" hello user start your journey")
                .font(.title3)
                .hAlign(.leading)
            //for smaller sizes optimization
            ViewThatFits{
                ScrollView(.vertical,showsIndicators: false){
                    HelperView()
                }
                HelperView()
            }
            
            
        }
        //register button
        HStack{
            Text("Already have an account ")
                .foregroundColor(.gray)
            
            Button("login  now ! "){
                dismiss()
            }
            .fontWeight(.bold)
            .foregroundColor(.black)
        
        .font(.callout)
        .vAlign(.bottom)
    }
        
        .vAlign(.top)
        .padding(15)
        photosPicker(isPresented:     $showImagePicker , selection: $photoItem)
            .onChange(of: photoItem){
                newValue in if let newValue{
                    Task{
                        do{
                            guard let imageData = try await newValue.loadTransferable (type: Data.self) else{return}
                            //UI must be updated on the first Tread
                            await MainActor.run (body: {
                                userProfilePicData = imageData
                            })
                        }catch{}
                        
                        
                        
                    }
                }
            }
    }
    @ViewBuilder
    func HelperView()->some View{
        VStack(spacing: 12){
            ZStack{
                if let userProfilePicData, let image = UIImage(data: userProfilePicData){
                    Image(uiImage: image )
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }else{
                    Image("NullProfile")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }
            }
            .frame(width: 85, height: 85)
            .clipShape(Circle())
            .contentShape(Circle())
            .onTapGesture {
                showImagePicker.toggle()
            }
            .padding(25)
            
            TextField("user name", text: $userName )
                .textContentType(.emailAddress )
                .border(1, .gray.opacity(0.5))
            
            
            TextField("Email", text: $emailID )
                .textContentType(.emailAddress )
                .border(1, .gray.opacity(0.5))
            
            
            
            SecureField("password", text: $password )
                .textContentType(.emailAddress )
                .border(1, .gray.opacity(0.5))
            
            TextField("about you", text: $userBio,axis: .vertical)
                .frame(minHeight: 100,alignment: .top )
                .textContentType(.emailAddress )
                .border(1, .gray.opacity(0.5))
            TextField("Bio Link(Optional)", text: $userBioLink )
                .textContentType(.emailAddress )
                .border(1, .gray.opacity(0.5))
            
            
            Button{
                
            }label:{
                //login Button
                Text("sign up ")
                    .foregroundColor(.white )
                    .hAlign(.center)
                    .fillView(.black)
            }
            .padding(.top ,10  )
        }
    }
    
}

struct RegisterationView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

