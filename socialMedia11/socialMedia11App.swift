//
//  socialMedia11App.swift
//  socialMedia11
//
//  Created by marwa awwad mohamed awwad on 11.07.2023.
//

import SwiftUI
import Firebase



@main
struct socialMedia11App: App {
    //to insilize firebase
    init(){
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
