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
                    for value in 0..<9 {
                        self.userViewModel.addWatchList(watchItem: Episodes(audio: "hi", audio_length: 100, description: "hi", episode_uuid: String(value), podcast_uuid: "hi", pub_date: "2022/09/09", title: "hi", image: "hi", user_id: self.userSettings.uuid))
                    }
                }
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
