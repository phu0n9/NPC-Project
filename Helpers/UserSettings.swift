//
//  UserSettings.swift
//  NPC
//
//  Created by Nguyen Huynh Phuong Anh on 01/09/2022.
//

import Foundation
class UserSettings: ObservableObject {
    @Published var token: String {
        didSet {
            UserDefaults.standard.set(token, forKey: Settings.userToken)
        }
    }
    
    @Published var uuid: String {
        didSet {
            UserDefaults.standard.set(uuid, forKey: Settings.uuid)
        }
    }
    
    init() {
        self.token = UserDefaults.standard.string(forKey: Settings.userToken) ?? ""
        self.uuid = UserDefaults.standard.string(forKey: Settings.uuid) ?? ""
    }
}
