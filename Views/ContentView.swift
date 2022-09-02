//
//  ContentView.swift
//  NPC
//
//  Created by Nguyen Huynh Phuong Anh on 29/08/2022.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var userViewModel = UserViewModel()
    @ObservedObject var userSettings = UserSettings()
    
    var body: some View {
        Text("Hello, world!")
            .padding()
            .onAppear {
                DispatchQueue.main.async {
                    self.userViewModel.fetchUsers(uuid: self.userSettings.uuid)
                    print(self.userViewModel.user)
                }
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
