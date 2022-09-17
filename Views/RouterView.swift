//
//  ViewRouter.swift
//  NPC
//
//  Created by Le Nguyen on 12/09/2022.
//

import SwiftUI

class RouterView: ObservableObject {
    // By default it direct the user to the user welcome page
    @Published var currentPage: Page = .bottomNavBar
}

enum Page {
    case welcome
    case login
    case trending // In case we want to access these page
    case activity
    case profile
    case castingUser
    case castingCommunity
    case bottomNavBar
}
