/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2022B
  Assessment: Assignment 3
  Authors:
    Nguyen Huynh Anh Phuong - s3695662
    Le Nguyen - s3777242
    Han Sangyeob - s3821179
    Nguyen Anh Minh - s3911237
  Created  date: 29/08/2022
  Last modified: 18/09/2022
  Acknowledgments: StackOverflow, Youtube, and Mr. Tom Huynh’s slides
*/

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
    @State var download = Downloads(audio: "", title: "", isProcessing: false)
    @StateObject var userViewModel = UserViewModel()
    
    // PopupView
    @State private var showToast = false
    @State private var value = 0
    
    var body: some View {
        
        ScrollView {
            // MARK: Podcast horizontal scroll view
            HStack(alignment: .firstTextBaseline) {
                Text("Podcast for you")
                    .fontWeight(.regular)
                    .foregroundColor(Color("MainButton"))
                    .frame(alignment: .topTrailing)
                    .padding(5.0)
                    .font(.system(size: 20))
          
                Spacer()
            }
            .padding(5)

            ScrollView(.horizontal) {
                HStack(spacing: 10) {
                    ForEach(self.podcastViewModel.podcasts, id: \.id) { podcast in
                        PodcastComponent(podcast: podcast)
                    }
                }
            }
            
            Divider()
            
            //  MARK: recommendation podcasts
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
                        ForEach(self.podcastViewModel.randomPodcasts, id: \.id) { podcast in
                            MiddleComponent(podcast: podcast)
                        }
                    }
                }
            
            Divider()
            
            // MARK: episodes based on the user preferences
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
                                        episode.isTapped.toggle()
                                    }
                                    .onChange(of: episode.isTapped) { value in
                                        if value {
                                            self.episode = episode
                                            self.isTapped.toggle()
                                        }
                                    }
                            }
                        }
                    }
                }
            }
        }
        .sheet(isPresented: self.$isTapped) {
            StreamingView(episode: self.$episode, upload: self.$upload, download: self.$download, state: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.height - 200)
        .onAppear {
            DispatchQueue.main.async {
                self.podcastViewModel.fetchPodcasts(categories: self.userSettings.userCategories, isRandom: false)
                self.podcastViewModel.fetchPodcasts(categories: [], isRandom: true)
            }
        }
        
    }
}

struct TrendingView_Previews: PreviewProvider {
    static var previews: some View {
        TrendingView()
    }
}
