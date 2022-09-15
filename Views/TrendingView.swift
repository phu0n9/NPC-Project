//
//  TrendingView.swift
//  NPC
//
//  Created by Le Nguyen on 02/09/2022.
//

import SwiftUI
import UIKit
import PopupView

struct TrendingView: View {
    
    @ObservedObject var podcastViewModel = PodcastViewModel()
    @ObservedObject var userSettings = UserSettings()
    @State var time = Timer.publish(every: 0.1, on: .main, in: .tracking).autoconnect()
    @EnvironmentObject var routerView: RouterView
    @State private var isTapped: Bool = false
    @State private var episode = Episodes(audio: "", audio_length: 0, description: "", episode_uuid: "", podcast_uuid: "", pub_date: "", title: "", image: "", user_id: "", isLiked: false)
    @State private var upload = Uploads(title: "", description: "", audioPath: "", author: "", pub_date: "", image: "", userID: "", numOfLikes: 0, audio_length: 0, userImage: "", likes: [], comments: [])
    
    var body: some View {
        
        ScrollView {

            HStack(alignment: .firstTextBaseline) {
                Text("Podcast for you")
                    .fontWeight(.regular)
                    .foregroundColor(Color("MainButton"))
                    .frame(alignment: .topTrailing)
                    .padding(5)
                    .font(.system(size: 20))
                
                Spacer()
            }.padding(5)

            ScrollView(.horizontal) {
                HStack(spacing: 10) {
                    ForEach(self.podcastViewModel.podcasts, id: \.id) { podcast in
                        PodcastComponent(podcast: podcast)
                    }
                }
            }
            
            Divider()
            
            //MARK: MIDDLE ELEMENTS
            ScrollView {
                HStack(alignment: .firstTextBaseline) {
                    Text("Recommendations")
                        .fontWeight(.regular)
                        .foregroundColor(Color("MainButton"))
                        .frame(alignment: .topTrailing)
                        .padding(5)
                        .font(.system(size: 20))
                    Spacer()
                }.padding(5)

                ScrollView(.horizontal) {
                    HStack(spacing: 10) {
                        ForEach(self.podcastViewModel.podcasts, id: \.id) { podcast in
                            MiddleComponent(podcast: podcast)
                        }
                    }
                   
                }
            }
            
            
            Divider()
            
            ScrollView {
                LazyVStack {
                    HStack(alignment: .firstTextBaseline) {
                    
                        Text("Your Episodes")
                            .fontWeight(.regular)
                            .foregroundColor(Color("MainButton"))
                            .frame(alignment: .topTrailing)
                            .padding(5)
                            .font(.system(size: 20))
                        Spacer()
                         
                    }.padding(10)
                    ForEach(self.$podcastViewModel.paginatedEpisodes, id: \.id) { $episode in
                        
                        ZStack {
                            // reaching end of the list then load new data
                            if self.podcastViewModel.paginatedEpisodes.last?.id == episode.id && self.podcastViewModel.isFetchingMore {
                                GeometryReader { bounds in
                                    LoadingEpisodeRows()
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
                                EpisodeComponent(episode: $episode, isExpanded: $episode.isExpanding)
                                    .onTapGesture {
                                        self.isTapped = true
                                        self.episode = episode
                                    }
                            }
                        }
                    }
                }
            }
        }
        .popup(isPresented: self.$isTapped, type: .toast, position: .bottom, closeOnTap: false, backgroundColor: .black.opacity(0.4)) {
            StreamingView(episode: self.$episode, upload: self.$upload, state: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.height - 200)
        .onAppear {
            DispatchQueue.main.async {
                self.podcastViewModel.fetchPodcasts(categories: self.userSettings.userCategories)
            }
        }
    }
    
    private func allowShowNotification(){
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]){success,_ in
            guard success else {
                return
            }
            print("Succesfully Allow Notification")
        }
    }
}

struct TrendingView_Previews: PreviewProvider {
    static var previews: some View {
        TrendingView()
    }
}
