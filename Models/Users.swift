//
//  Users.swift
//  NPC
//
//  Created by Nguyen Huynh Phuong Anh on 30/08/2022.
//

import Foundation
struct Users : Identifiable, Codable {
    var id : String = UUID().uuidString
    var token : String
    var email : String
    var userName : String
    var profilePic : String
}
