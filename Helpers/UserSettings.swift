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
    
    @Published var username: String {
        didSet {
            UserDefaults.standard.set(username, forKey: Settings.userName)
        }
    }
    
    @Published var userCategories: [String] {
        didSet {
            UserDefaults.standard.set(userCategories, forKey: Settings.userCategories)
        }
    }
    
    init() {
        self.token = UserDefaults.standard.string(forKey: Settings.userToken) ?? ""
        self.uuid = UserDefaults.standard.string(forKey: Settings.uuid) ?? ""
        self.username = UserDefaults.standard.string(forKey: Settings.userName) ?? ""
        self.userCategories = UserDefaults.standard.array(forKey: Settings.userCategories) as? [String] ?? ["Music", "Arts"]
    }
}
