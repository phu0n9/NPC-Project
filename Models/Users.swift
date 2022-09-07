//
//  Users.swift
//  NPC
//
//  Created by Nguyen Huynh Phuong Anh on 30/08/2022.
//

import Foundation
struct Users : Identifiable {
    var id : String = UUID().uuidString
    var uuid: String
    var token : String = UserSettings().token == "" ? UUID().uuidString : UserSettings().token
    var email : String
    var userName : String
    var profilePic : String
    var favoriteTopics : [String]
    var uploadedList : [Uploads]
    var watchedList: [Episodes]
    var favoriteList : [Episodes]
}
