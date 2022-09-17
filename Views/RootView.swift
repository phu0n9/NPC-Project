//
//  MotherView.swift
//  NPC
//
//  Created by Le Nguyen on 12/09/2022.
//

import SwiftUI

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
