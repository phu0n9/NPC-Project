//
//  PodcastDetailView.swift
//  NPC
//
//  Created by Nguyen Huynh Phuong Anh on 13/09/2022.
//

import SwiftUI
import PopupView

struct PodcastDetailView: View {
    var podcast: Podcasts
    @State var time = Timer.publish(every: 0.1, on: .main, in: .tracking).autoconnect()
    @ObservedObject var podcastViewModel = PodcastViewModel()
    @ObservedObject var userSettings = UserSettings()
    @State private var isTapped: Bool = false
    @State private var episode = Episodes(audio: "", audio_length: 0, description: "", episode_uuid: "", podcast_uuid: "", pub_date: "", title: "", image: "", user_id: "", isLiked: false)
    @State private var upload = Uploads(title: "", description: "", audioPath: "", author: "", pub_date: "", image: "", userID: "", numOfLikes: 0, audio_length: 0, likes: [], comments: [])
    @State var isExpanded : Bool = false

    var body: some View {
        ScrollView {
            VStack {
                HStack{
                
                    
                    VStack {
                        Text(self.podcast.title)
                            .font(.title3)
                            .frame(maxWidth: 400, alignment: .leading)
                            .lineLimit(1)
                        Text(self.podcast.author)
                            .font(.caption)
                            .frame(maxWidth: 400, alignment: .leading)
//                        Image(systemName: "globe")
//                            .renderingMode(.template)
//                            .frame(width:20, height: 20, alignment: .leading)

                    }.padding()
                    
                    AsyncImage(url: URL(string: self.podcast.image)) { podcastImage in
                        
                        podcastImage
                            .resizable()
                            .font(.title)
                            .frame(width: 90, height: 90, alignment: .leading)
                            .foregroundColor(.orange)
                            .cornerRadius(20)
                    } placeholder: {
                        ProgressView()
                    }.padding()
                    
                }.padding(0)
                Text(self.podcast.description)
                    .lineLimit(isExpanded ? nil : 4)
                    .padding()


                Divider()

                Text("Avaliable Episodes")
                    .fontWeight(.regular)
                    .font(.system(size: 20))
                    .frame(width: 300, height: 50, alignment: .leading)
                    .padding(0)
                
                LazyVStack {
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
                self.podcastViewModel.fetchPodcastById(podcastId: self.podcast.uuid, episodeId: "")
            }
        }
    }
}

//struct PodcastDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        PodcastDetailView(podcast: Podcasts(uuid: "", author: "", description: "", image: "", itunes_id: 23, language: "", title: "", website: "", categories: ["Technology", "Arts"], episodes: []))
//    }
//}

struct PodcastDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PodcastDetailView(podcast: Podcasts(uuid: "0c28802a7e814a55ada3ba54847258bc", author: "Sky", description: "Every episode Tim, Kyle and Sky play the Wiki game and attempt to get from one specific Wikipedia article to another only through the links within the articles.", image: "http://is5.mzstatic.com/image/thumb/Music71/v4/f8/a3/3e/f8a33e4e-bd23-ca5d-1aa2-bdb0e6b0f74b/source/600x600bb.jpg", itunes_id: 23, language: "English", title: "We Should Know Better", website: "http://wskbcast.blogspot.com/", categories: ["Technology", "Arts"], episodes: []))
    }
}
