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
struct Users : Identifiable {
    var id : String = UUID().uuidString
    var uuid: String
    var token : String = UserSettings().token == "" ? UUID().uuidString : UserSettings().token
    var email : String
    var userName : String
    var profilePic : String
    var favoriteTopics : [String]
}
