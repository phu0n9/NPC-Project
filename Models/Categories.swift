//
//  Categories.swift
//  NPC
//
//  Created by Nguyen Huynh Phuong Anh on 31/08/2022.
//

import Foundation

struct Categories: Identifiable, Codable {
    var id : String = UUID().uuidString
    var categories : String
    var checked: Bool = false
}
