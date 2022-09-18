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

// MARK: root view for switching child view to parent view
struct RootView: View {
    
    @EnvironmentObject var routerView: RouterView
    
    var body: some View {
        switch routerView.currentPage {
        case .welcome:
            WelcomeView()
        case .login:
            LoginView()
        case .trending:
            TrendingView()
        case .profile:
            ProfileView()
        case .activity:
            ActivityView()
        case .castingUser:
            ViewComponent(destination: CastingView(currentTab: 1), viewTitle: "Casting")
        case .castingCommunity:
            CastingView(currentTab: 0)
        case .bottomNavBar:
            BottomNavBar()
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView().environmentObject(RouterView())
    }
}
