//
//  WelcomeView.swift
//  NPC
//
//  Created by Nguyen Huynh Phuong Anh on 01/09/2022.
//

import SwiftUI

struct WelcomeView: View {
    
    @ObservedObject private var userViewModel = UserViewModel()
    @State private var yAxis : CGFloat = 0
    @State private var addThis : CGFloat = 50
    @State private var isActive: Bool?
    @EnvironmentObject var routerView: RouterView
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.welcomeBackground.ignoresSafeArea()
                VStack {
                    ZStack {
                        Color.orange.opacity(0.05).ignoresSafeArea()
                        Image("welcomeScreen")
                            .resizable()
                            .frame(maxWidth: 372, maxHeight: 534)
                            .aspectRatio(contentMode: .fit)
                            .offset(x: 0, y: yAxis)
                            .onAppear {
                                Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                                    withAnimation(.easeInOut(duration: 2.0)) {
                                        self.addThis = -self.addThis
                                        self.yAxis += self.addThis
                                    }
                                }
                            }
                    }
                }
            }
        }
        .onAppear {
            DispatchQueue.main.async {
                self.userViewModel.checkUserValidation()
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                withAnimation {
                    if self.userViewModel.userSettings.token != "" && self.userViewModel.isValid {
                        self.routerView.currentPage = .bottomNavBar
                    } else {
                        self.routerView.currentPage = .login
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}

extension Color {
    static let welcomeBackground = Color("WelcomeView")
}
