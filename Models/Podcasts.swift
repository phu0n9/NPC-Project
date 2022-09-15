//
//  Podcasts.swift
//  NPC
//
//  Created by Nguyen Huynh Phuong Anh on 31/08/2022.
//

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
}

