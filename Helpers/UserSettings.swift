/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2022B
  Assessment: Assignment 3
  Authors:
    Nguyen Huynh Anh Phuong - s3695662
    Le Nguyen - s3777242
    Han Sangyeob - s3821179
    Nguyen Anh Minh - s3911237
  Created  date: 29/08/2022
  Last modified: 18/09/2022
  Acknowledgments: StackOverflow, Youtube, and Mr. Tom Huynh’s slides
*/

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
    
    @Published var userImage : String {
        didSet {
            UserDefaults.standard.set(userImage, forKey: Settings.userImage)
        }
    }
    
    init() {
        self.token = UserDefaults.standard.string(forKey: Settings.userToken) ?? ""
        self.uuid = UserDefaults.standard.string(forKey: Settings.uuid) ?? ""
        self.username = UserDefaults.standard.string(forKey: Settings.userName) ?? ""
        self.userCategories = UserDefaults.standard.array(forKey: Settings.userCategories) as? [String] ?? ["Music", "Arts"]
        self.userImage = UserDefaults.standard.string(forKey: Settings.userImage) ?? ""
    }
}
