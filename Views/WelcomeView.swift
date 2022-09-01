//
//  WelcomeView.swift
//  NPC
//
//  Created by Nguyen Huynh Phuong Anh on 01/09/2022.
//

import SwiftUI

struct WelcomeView: View {
    
    @ObservedObject private var userViewModel = UserViewModel()
    @State private var isChanged = false
    @State var state = 0
    
    var body: some View {
        NavigationView {
            NavigationLink(destination: chooseDestination(), isActive: $isChanged) {
                Text("Welcome")
            }
        }
        .onAppear {
            let group = DispatchGroup()
            group.enter()
            DispatchQueue.main.async {
                self.userViewModel.checkUserValidation()
                group.leave()
            }
            group.wait()
            if self.userViewModel.userSettings.token != "" || self.userViewModel.isValid {
                self.state = 1
            }
        }
    }
    
    @ViewBuilder
    func chooseDestination() -> some View {
        switch state {
            case 0: LoginView()
            case 1: ContentView()
            default: EmptyView()
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
