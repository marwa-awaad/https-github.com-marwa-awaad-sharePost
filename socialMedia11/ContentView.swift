//
//  ContentView.swift
//  socialMedia11
//
//  Created by marwa awwad mohamed awwad on 11.07.2023.
//

import SwiftUI
import Firebase


struct ContentView: View {
    @AppStorage("log_status") var logStatus: Bool = false
    
    var body: some View {
        //        if logStatus{
        //      MainView()
        //        }else {
        //            LoginView()
        //        }
        
        
       create_new_post{ _ in
            
        }
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
