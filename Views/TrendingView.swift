//
//  TrendingView.swift
//  NPC
//
//  Created by Le Nguyen on 02/09/2022.
//

import SwiftUI

struct TrendingView: View {
    @ObservedObject var podcastViewModel = PodcastViewModel()
    @ObservedObject var userSettings = UserSettings()
    
    var body: some View {
        ScrollView {
            ScrollView(.horizontal) {
                HStack(spacing: 10) {
                    ForEach(0..<10, id: \.self) { _ in
                        PodcastComponent()
                    }
                }.padding()
        }

            Divider()
            Divider()
            
            ScrollView {
                LazyVStack {
                    ForEach(0 ... 20, id: \.self) { _ in
                        EpisodeComponent()
                    }
                }
            }
        }
        .onAppear {
            DispatchQueue.main.async {
                self.podcastViewModel.fetchPodcasts(categories: self.userSettings.userCategories)
                print(self.podcastViewModel.podcasts)
                print(self.podcastViewModel.episodes)
            }
        }
    }
}

struct TrendingView_Previews: PreviewProvider {
    static var previews: some View {
        TrendingView()
    }
}
