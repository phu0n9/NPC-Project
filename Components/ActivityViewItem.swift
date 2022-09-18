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

struct ActivityViewItem: View {
    @StateObject var userViewModel = UserViewModel()
    @State var selectedTab : Int
    @State private var time = Timer.publish(every: 0.1, on: .main, in: .tracking).autoconnect()
    @Binding var currentTabCollection: String
    @Binding var currentTabTitle: String
    @State var isTapped = false
    @State private var episode = Episodes(audio: "", audio_length: 0, description: "", episode_uuid: "", podcast_uuid: "", pub_date: "", title: "", image: "", user_id: "", isLiked: false)
    @State private var upload = Uploads(title: "", description: "", audioPath: "", author: "", pub_date: "", image: "", userID: "", numOfLikes: 0, audio_length: 0, userImage: "", likes: [], comments: [])
    @State var download = Downloads(audio: "", title: "", isProcessing: false)
    @State var isLoading = true
    
    var body: some View {
        ZStack {
            if self.isLoading {
                TransitionView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            self.isLoading.toggle()
                        }
                    }
            } else {
                ScrollView {
                    VStack {
                        if self.userViewModel.userActivityList.isEmpty {
                            EmptyListView(title: self.currentTabTitle)
                        } else {
                            ForEach(self.$userViewModel.userActivityList, id: \.id) { $item in
                                ZStack {
                                    // reaching end of the list then load new data
                                    if self.userViewModel.userActivityList.last?.id == item.id {
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
                                        .frame(height: 150)
                                    } else {
                                        // return original data
                                        EpisodeComponent(episode: $item, isExpanded: $item.isExpanding)
                                            .onTapGesture {
                                                item.isTapped.toggle()
                                            }
                                            .onChange(of: item.isTapped) { value in
                                                if value {
                                                    self.episode = item
                                                    self.isTapped.toggle()
                                                }
                                            }
                                            .onChange(of: item.isLiked) { (_) in
                                                self.isLoading.toggle()
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
                    StreamingView(episode: self.$episode, upload: self.$upload, download: self.$download, state: 0)
                }
            }
        }
    }
}
