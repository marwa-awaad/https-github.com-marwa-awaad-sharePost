//
//  LoginView.swift
//  socialMedia11
//
//  Created by marwa awwad mohamed awwad on 11.07.2023.
//

import SwiftUI
import PhotosUI
import Firebase
import FirebaseStorage
import FirebaseFirestore



struct LoginView: View {
    @State var emailID: String = ""
    @State var password: String = ""
    
    //default properties
    @State var createAccount: Bool = false
    @State var showError : Bool = false
    @State var errorMessage : String = ""
    @State var isLoading: Bool = false
    @AppStorage("user_profile_url") var profileURL: URL?
    @AppStorage("user_name") var userNameStored: String = ""
    @AppStorage("user_UID") var userUID: String = ""
    @AppStorage("log_status") var logStatus:Bool = false
    
    
    var body: some View {
        VStack(spacing: 10){
            Text ("Let' s Sign you in")
                .font (.largeTitle.bold ())
                .hAlign(.leading )
            
            Text("welcome back\n you have been missed ")
                .font(.title3)
                .hAlign(.leading)
            
            VStack(spacing: 12){
                
                
                TextField("Email", text: $emailID )
                    .textContentType(.emailAddress )
                    .border(1, .gray.opacity(0.5))
                    .padding(.top,25)
                
                
                SecureField("password", text: $password )
                    .textContentType(.emailAddress )
                    .border(1, .gray.opacity(0.5))
                
                Button("Reset Password ?",action: loginUser)
                    .font(.callout)
                    .fontWeight(.medium)
                    .tint(.black )
                    .hAlign(.trailing   )
                
                Button{
                    
                }label:{
                    //login Button
                    Text("Login")
                        .foregroundColor(.white )
                        .hAlign(.center)
                        .fillView(.black)
                }
                .padding(.top ,10  )
                
                //register button
                HStack{
                    Text("don't have an account")
                        .foregroundColor(.gray)
                    
                    Button("Register now"){
                        createAccount.toggle()
                        
                    }
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    
                }
                .font(.callout)
                .vAlign(.bottom)
                
            } 
            .vAlign(.top)
            .padding(15)
            .overlay(content:{
            //     LoadingView(show: $isLoading)
                
            })
            //register via sheets
            .fullScreenCover(isPresented: $createAccount){
                RegisterView()
            }
            .alert(errorMessage, isPresented: $showError, actions:{})
        }
    }
    func loginUser(){
        isLoading = true
        Task{
            do{
                try await Auth.auth().signIn(withEmail: emailID, password: password)
                print("user found")
                //  try await fetchUser()
            }catch{
                await setError(error)
            }
        }
    }
    
    //to fetch the user data
    
    //
    func resetPassword(){
        Task{
            do{
                try await Auth.auth().sendPasswordReset(withEmail: emailID)
                print("user found")
            }catch{
                await setError(error)
            }
        }
    }
    func setError(_ error: Error)async{
        await MainActor.run(body: {
            errorMessage = error.localizedDescription
            showError.toggle()
            isLoading = false
        })
    }
    
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
        var body: some View{
            VStack(spacing: 12){
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
            }
            .font(.callout)
            .vAlign(.bottom)
            
            
            .vAlign(.top)
            .padding(15)
            photosPicker(isPresented: $showImagePicker , selection: $photoItem)
                .onChange(of: photoItem){
                    newValue in if let newValue{
                        Task{
                            do{
                                guard let imageData = try await newValue.loadTransferable (type: Data.self) else{return}
                                
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
    
    struct LoginView_Preview: PreviewProvider {
        static var previews: some View{
            ContentView()
        }
    }
    
    
}
    

