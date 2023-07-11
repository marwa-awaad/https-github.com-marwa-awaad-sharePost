//
//  posts.swift
//  socialMedia11
//
//  Created by marwa awwad mohamed awwad on 12.07.2023.
//

import SwiftUI
import FirebaseFirestoreSwift
//post model
 
struct Post: Identifiable,Codable {
    
   @DocumentID
    
    var text: String
   var imageURL: URL?
     var imageReferenceID: String = ""
    var publishedDate: Date = Date ()
var likedIDs: [String] = []
var dislikedIDs: [String] = []
// MARK: Basic User Info
var userName: String
var userUID: String
var userProfIleURL: URL
    
 enum CodingKeys: CodingKey {


case PostText
case imageURL
case imageReferenceID
case publishedDate
case likedIDs
case dislikedIDs
case userName
case userUID
case userProfileURL
    
    
}
    
}
