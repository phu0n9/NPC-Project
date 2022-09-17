//
//  Download.swift
//  NPC
//
//  Created by Nguyen Huynh Phuong Anh on 16/09/2022.
//

import Foundation
struct Downloads: Identifiable {
    var id: String = UUID().uuidString
    var audio: String
    var title: String
    var isProcessing: Bool
    var isTapped: Bool = false
}
