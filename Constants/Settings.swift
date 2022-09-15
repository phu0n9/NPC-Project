//
//  Settings.swift
//  NPC
//
//  Created by Nguyen Huynh Phuong Anh on 30/08/2022.
//

import Foundation
import SwiftUI

struct Settings {
    // MARK: Firebase Collections
    static let podcastsCollection = "podcasts"
    static let categoriesCollection = "categories"
    static let usersCollection = "users"
    static let uploadsCollection = "uploads"
    static let watchListCollection = "watchedLists"
    static let favoriteListCollection = "favoriteLists"
    static let commentListCollection = "commentList"
    static let likeListCollection = "likeList"
    
    // MARK: User Defaults
    static let userToken = "token"
    static let uuid = "uuid"
    static let userName = "userName"
    static let userCategories = "userCategories"
    static let download = "download"
    static let userImage = "userImage"
    
    // MARK: Firebase Messaging URL
    static let firebaseURL = "https://fcm.googleapis.com/v1/projects/npc-project-742bd/messages:send"
    static let serverKey = " AAAAT9V76q8:APA91bH_Vv5rXqAwiJcj1sGLIoV_I4oeqdWNxV04xklz8U2F1qDaev2eouP350NPYpI-EajyA5Eprm7VgTtSSC-X4rHK1Z-kXRS5RtF5I4hVkPNsVKu9rKaEw2pDtCXeHbx8ZZNP_V3y "
}
