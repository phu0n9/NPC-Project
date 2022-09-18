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

import SwiftUI

// MARK: handle switching views
class RouterView: ObservableObject {
    // By default it direct the user to the user welcome page
    @Published var currentPage: Page = .welcome
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
