//
//  ActivityViewItem.swift
//  NPC
//
//  Created by Nguyen Huynh Phuong Anh on 12/09/2022.
//

import SwiftUI

struct ActivityViewItem: View {
    @StateObject var userViewModel = UserViewModel()
    @State var selectedTab : Int
    @State private var time = Timer.publish(every: 0.1, on: .main, in: .tracking).autoconnect()
    @Binding var currentTabCollection: String
    @Binding var currentTabTitle: String
    @State var isTapped = false
    @State private var episode = Episodes(audio: "", audio_length: 0, description: "", episode_uuid: "", podcast_uuid: "", pub_date: "", title: "", image: "", user_id: "", isLiked: false)
    @State private var upload = Uploads(title: "", description: "", audioPath: "", author: "", pub_date: "", image: "", userID: "", numOfLikes: 0, audio_length: 0, userImage: "", likes: [], comments: [])
    
    var body: some View {
        ScrollView {
            VStack {
                if self.userViewModel.userActivityList.isEmpty {
                    EmptyListView(title: self.currentTabTitle)
                } else {
                    ForEach(self.$userViewModel.userActivityList, id: \.id) { $item in
                        ZStack {
                            // reaching end of the list then load new data
                            if self.userViewModel.userActivityList.last?.id == item.id && self.userViewModel.fetchingMore {
                                GeometryReader { bounds in
                                    LoadingEpisodeRows()
                                        .onAppear {
                                            self.time = Timer.publish(every: 0.1, on: .main, in: .tracking).autoconnect()
                                        }
                                        .onReceive(self.time) { (_) in
                                            if bounds.frame(in: .global).maxY < UIScreen.main.bounds.height - 80 {
                                                self.userViewModel.fetchUserActivityList(listName: self.currentTabCollection)
                                                self.time.upstream.connect().cancel()
                                            }
                                        }
                                }
                                .frame(height: 300)
                            } else {
                                // return original data
                                EpisodeComponent(episode: $item, isExpanded: $item.isExpanding, isTapped: self.$isTapped)
                                    .onTapGesture {
                                        self.isTapped = true
                                        self.episode = item
                                    }
                            }
                        }
                    }
                }
            }
        }
        .onAppear {
            DispatchQueue.main.async {
                if self.currentTabTitle != "Download List" {
                    self.userViewModel.fetchUserActivityList(listName: currentTabCollection)
                }
            }
        }
        .sheet(isPresented: self.$isTapped) {
            StreamingView(episode: self.$episode, upload: self.$upload, state: 0)
        }
    }
}
