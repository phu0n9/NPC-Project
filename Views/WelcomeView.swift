//
//  WelcomeView.swift
//  NPC
//
//  Created by Nguyen Huynh Phuong Anh on 01/09/2022.
//

import SwiftUI

struct WelcomeView: View {
    
    @ObservedObject private var userViewModel = UserViewModel()
    @State var state = 0
    @State private var isActive = false
    @State private var yAxis :CGFloat = 0
    @State private var addThis: CGFloat = 50
    
    var body: some View {
        NavigationView {
            NavigationLink(destination: chooseDestination(), isActive: $isActive) {
                ZStack {
                    Image("transition")
                        .resizable()
                        .frame(maxWidth: 300, maxHeight: 250)
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
        .onAppear {
            DispatchQueue.main.async {
                self.userViewModel.checkUserValidation()
            }
            DispatchQueue.main.asyncAfter(deadline: .now()+3.0) {
                withAnimation {
                    if self.userViewModel.userSettings.token != "" || self.userViewModel.isValid {
                        self.state = 1
                        self.isActive = true
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    func chooseDestination() -> some View {
        switch state {
        case 0: LoginView()
        case 1: BottomNavBar()
        default: EmptyView()
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
