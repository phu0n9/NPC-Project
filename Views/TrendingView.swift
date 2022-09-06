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
                    ForEach(self.podcastViewModel.podcasts, id: \.id) { podcast in
                        PodcastComponent(title: podcast.title, image: podcast.image, author: podcast.author)
                    }
                }.padding()
            }
            
            Divider()
            Divider()
            
            // TODO: more button behavior not correct
            ScrollView {
                LazyVStack {
                    ForEach(self.$podcastViewModel.episodes, id: \.id) { $episode in
                        EpisodeComponent(title: episode.title, pub_date: episode.pub_date, description: episode.description, audio: episode.audio, image: episode.image, isExpanded: $episode.isExpanding)
                    }
                }
            }
        }
        .onAppear {
            DispatchQueue.main.async {
                self.podcastViewModel.fetchPodcasts(categories: self.userSettings.userCategories, numberOfItems: 10)
            }
        }
    }
}

struct TrendingView_Previews: PreviewProvider {
    static var previews: some View {
        TrendingView()
    }
}
