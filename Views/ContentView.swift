//
//  ContentView.swift
//  NPC
//
//  Created by Nguyen Huynh Phuong Anh on 29/08/2022.
//

import SwiftUI

struct ContentView: View {
    @StateObject var podcastViewModel: PodcastViewModel = PodcastViewModel()
    
    var body: some View {
        Text("Hello, world!")
            .padding()
            .onAppear {
                DispatchQueue.main.async {
                    self.podcastViewModel.fetchPodcasts(categories: ["Tech News", "Technology"])
//                    self.podcastViewModel.fetchCategories()
                    
                }
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
