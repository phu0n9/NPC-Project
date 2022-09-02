//
//  Uploads.swift
//  NPC
//
//  Created by Nguyen Huynh Phuong Anh on 02/09/2022.
//

import Foundation

struct Uploads : Identifiable {
    var id : String = UUID().uuidString
    var uuid: String
    var title : String
    var description : String
    var audioPath : String
    var author: String
    var pub_date: String
    var image: String
    var language: String
    var userID : String
}
