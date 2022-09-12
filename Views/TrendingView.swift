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
    @State var time = Timer.publish(every: 0.1, on: .main, in: .tracking).autoconnect()
    
    @State var logoutSuccess = false
    @EnvironmentObject var viewRouter: ViewRouter
    
    var body: some View {
        ScrollView {
            NavigationLink("", destination: LoginView(), isActive: self.$logoutSuccess)
                .isDetailLink(false)
            ScrollView(.horizontal) {
            
                HStack(spacing: 10) {
                    ForEach(self.podcastViewModel.podcasts, id: \.id) { podcast in
                        PodcastComponent(title: podcast.title, image: podcast.image, author: podcast.author)
                    }
                }.padding()
            }
            
            Divider()
            Divider()
            
            ScrollView {
                LazyVStack {
                    ForEach(self.$podcastViewModel.paginatedEpisodes, id: \.id) { $episode in
                        
                        ZStack {
                            // reaching end of the list then load new data
                            if self.podcastViewModel.paginatedEpisodes.last?.id == episode.id {
                                GeometryReader { bounds in
                                    LoadingRows()
                                        .onAppear {
                                            self.time = Timer.publish(every: 0.1, on: .main, in: .tracking).autoconnect()
                                        }
                                        .onReceive(self.time) { (_) in
                                            if bounds.frame(in: .global).maxY < UIScreen.main.bounds.height - 80 {
                                                self.podcastViewModel.paginateEpisodes()
                                                self.time.upstream.connect().cancel()
                                            }
                                        }
                                }
                                .frame(height: 300)
                            } else {
                                // return original data
                                EpisodeComponent(title: episode.title, pub_date: episode.pub_date, description: episode.description, audio: episode.audio, image: episode.image, isExpanded: $episode.isExpanding)
                            }
                        }
                    }
                }
            }
        }
        .onAppear {
            DispatchQueue.main.async {
                self.podcastViewModel.fetchPodcasts(categories: self.userSettings.userCategories)
            }
        }
    }
}

struct TrendingView_Previews: PreviewProvider {
    static var previews: some View {
        TrendingView()
    }
}
