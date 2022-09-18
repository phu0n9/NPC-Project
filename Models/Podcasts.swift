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

struct Podcasts: Identifiable {
    var id: String = UUID().uuidString
    var uuid: String
    var author: String
    var description : String
    var image: String
    var itunes_id : Int32
    var language: String
    var title: String
    var website: String
    var categories : [String]
    var episodes: [Episodes]
}

struct Episodes: Identifiable, Codable {
    var id: String = UUID().uuidString
    var audio: String
    var audio_length: Int
    var description: String
    var episode_uuid: String
    var podcast_uuid: String
    var pub_date: String
    var title: String
    var image: String
    var user_id : String
    var isLiked: Bool
    var isExpanding: Bool = false
    var isTapped: Bool = false
}
