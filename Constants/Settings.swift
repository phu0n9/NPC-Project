//
//  Settings.swift
//  NPC
//
//  Created by Nguyen Huynh Phuong Anh on 30/08/2022.
//

import Foundation

struct Settings {
    // MARK: Firebase Collections
    static let podcastsCollection = "podcasts"
    static let categoriesCollection = "categories"
    static let usersCollection = "users"
    static let storageLink = "gs://npc-project-742bd.appspot.com/"
    
    // MARK: User Defaults
    static let userToken = "token"
    static let uuid = "uuid"
    static let userName = "userName"
    static let userCategories = "userCategories"
}
