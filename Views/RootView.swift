//
//  MotherView.swift
//  NPC
//
//  Created by Le Nguyen on 12/09/2022.
//

import SwiftUI

struct RootView: View {
    
    @EnvironmentObject var viewRouter: ViewRouter
    
    var body: some View {
        switch viewRouter.currentPage {
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
        }
        
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView().environmentObject(ViewRouter())
    }
}
