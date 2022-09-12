//
//  ViewRouter.swift
//  NPC
//
//  Created by Le Nguyen on 12/09/2022.
//

import SwiftUI

class ViewRouter: ObservableObject {
    // By default it direct the user to the user welcome page
    @Published var currentPage: Page = .welcome
}

enum Page {
    case welcome
    case login
    case trending // In case we want to access these page
    case activity
    case profile
}
