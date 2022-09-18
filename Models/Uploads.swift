//
//  Uploads.swift
//  NPC
//
//  Created by Nguyen Huynh Phuong Anh on 02/09/2022.
//

import Foundation

struct Uploads : Identifiable {
    var id : String = UUID().uuidString
    var uuid: String = UUID().uuidString
    var title : String
    var description : String
    var audioPath : String
    var author: String
    var pub_date: String
    var image: String
    var userID : String
    var numOfLikes: Int
    var audio_length: Int
    var userImage: String
    var likes: [Likes]
    var comments: [Comments]
    var isTapped: Bool = false
}

struct Likes : Identifiable {
    var id: String = UUID().uuidString
    var author: String
    var userID: String
    var isLiked: Bool
}

struct Comments: Identifiable {
    var id: String = UUID().uuidString
    var uuid: String
    var author: String
    var userID: String
    var content: String
    var image : String
}
