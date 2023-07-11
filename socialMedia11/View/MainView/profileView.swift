//
//  profileView.swift
//  socialMedia11
//
//  Created by marwa awwad mohamed awwad on 11.07.2023.
//

import SwiftUI
import Firebase
import FirebaseStorage
import FirebaseFirestore

struct profileView: View {
    //profile data
    @State private var myProfile: User?
    @AppStorage("login_status") var logStatus : Bool = false
    @State var errorMessage: String = ""
    @State var showError: Bool = false
    @State var isLoading: Bool = false
     
    var body: some View {
        
        NavigationStack{ 
            VStack{
                if let myProfile  {
                    ReusableProfileContents(user:  myProfile)
                        .refreshable {
                            //refresh user data
                            self.myProfile = nil
                              await fetchUserData()
                        }
                }else{
                    ProgressView()
                }
            }
        
            .navigationTitle("My Profile")
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing){
                    Menu {
                        //two actions logout and deleting account
                        Button("logout",action: logOutUser )
                        Button("Delete your account",role: .destructive,action: deletingAccount)
                    }label:{
                        Image(systemName: "ellipsis")
                            .rotationEffect(.init(degrees: 90))
                            .tint(.black)
                            .scaleEffect(0.8)
                    }
                }
            }
            
        }
        .overlay{
           // LoadingView(show: $isLoading)
        }
        .alert(errorMessage, isPresented: $showError){
            
        } .task {
            //this modifier is like onApear
            //so fetch for first time only
            if myProfile != nil {return}
             //initial fetch
            await fetchUserData()
        }
    }
    //fetching user data
    func fetchUserData()async{
        guard let userUID  = Auth.auth().currentUser?.uid else{return}
        guard let user = try? await Firestore.firestore().collection("Usera").document(userUID).getDocument(as: User.self)
        else{return}
        
        await MainActor.run(body: {
            myProfile = user
        })
    }
    //logging user out
    func logOutUser(){
        try? Auth.auth().signOut()
        logStatus = false
    }
    func deletingAccount(){
        isLoading = true
        Task{
            do{
                guard let userUID = Auth.auth().currentUser?.uid else{return}
                //step 1: first deleting profile image from storage
                let reference = Storage.storage().reference().child("Profile_Images").child(userUID )
                try await reference.delete()
                //step 2:
                try await Firestore.firestore().collection("Users").document(userUID).delete()
                    //final Step : delete Auth account and setting log status to false
              try  await   Auth.auth().currentUser?.delete()
                logStatus = false
            }catch{
                await setError(error )
            }
            
        }
    }
    func setError(_ error : Error)async{
//        UI must be run on Main Thread
        await MainActor.run(body: {
            isLoading = false
            errorMessage = error.localizedDescription
            showError.toggle()
        })
    }
}

struct profileView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
