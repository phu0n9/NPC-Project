//
//  FirebaseManager.swift
//  NPC
//

import Foundation
import FirebaseAuth

class FirebaseManager: NSObject {

    let auth: Auth
    static let shared = FirebaseManager()

    override init() {
        self.auth = Auth.auth()

        super.init()
    }

}
