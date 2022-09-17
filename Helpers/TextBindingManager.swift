//
//  TextBindingManager.swift
//  NPC
//
//  Created by Nguyen Huynh Phuong Anh on 11/09/2022.
//

import Foundation
class TextBindingManager: ObservableObject {
    @Published var text = "" {
        didSet {
            if text.count > characterLimit && oldValue.count <= characterLimit {
                text = oldValue
            }
        }
    }
    let characterLimit: Int

    init(limit: Int = 5) {
        characterLimit = limit
    }
}
