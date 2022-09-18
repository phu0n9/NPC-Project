/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2022B
  Assessment: Assignment 3
  Authors:
    Nguyen Huynh Anh Phuong - s3695662
    Le Nguyen - s3777242
    Han Sangyeob - s3821179
    Nguyen Anh Minh - s3911237
  Created  date: 29/08/2022
  Last modified: 18/09/2022
  Acknowledgments: StackOverflow, Youtube, and Mr. Tom Huynh’s slides
*/

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
