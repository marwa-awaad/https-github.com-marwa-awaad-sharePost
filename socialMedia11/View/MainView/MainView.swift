//
//  MainView.swift
//  socialMedia11
//
//  Created by marwa awwad mohamed awwad on 11.07.2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct MainView: View {
    var body: some View {
        //tab view with recent posts and profile taps
        
        TabView{
            Text("Recent posts ")
                .tabItem{
                    Image (systemName:  "rectangle.portrait.on.rectangle.portrait.angled")
                    Text("post's  ")
                }
             
                    
                   profileView()
                        .tabItem{
                            Image (systemName:  "gear")
                            Text("profile")
                        }
                
        }
          
        // changing lab table tint to black
        .tint(.black )
    }
}
struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
