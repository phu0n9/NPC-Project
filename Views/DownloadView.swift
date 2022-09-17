//
//  DownloadView.swift
//  NPC
//
//  Created by Nguyen Huynh Phuong Anh on 16/09/2022.
//

import SwiftUI

struct DownloadView: View {
    @StateObject var downloadControl: DownloadControl = DownloadControl()
    @State var isTapped = false
    @State var download = Downloads(audio: "", title: "", isProcessing: false, audio_length: 0)
    @State private var episode = Episodes(audio: "", audio_length: 0, description: "", episode_uuid: "", podcast_uuid: "", pub_date: "", title: "", image: "", user_id: "", isLiked: false)
    @State private var upload = Uploads(title: "", description: "", audioPath: "", author: "", pub_date: "", image: "", userID: "", numOfLikes: 0, audio_length: 0, userImage: "", likes: [], comments: [])
    @State var selectedDownload = Downloads(audio: "", title: "", isProcessing: false, audio_length: 0)
    
    var body: some View {
        ScrollView {
            if self.downloadControl.downloads.isEmpty {
                EmptyListView(title: "Download List")
            } else {
                 ScrollView {
                    LazyVStack {
                        ForEach(self.$downloadControl.downloads, id: \.id) { $download in
                            // return original data
                            DownloadItem(download: $download, isTapped: self.$isTapped, selectedDownload: self.$selectedDownload)
                        }
                    }
                }
            }
        }
        .onAppear {
            DispatchQueue.main.async {
                self.downloadControl.fetchAllDownloads()
            }
        }
        .sheet(isPresented: self.$isTapped) {
            StreamingView(episode: self.$episode, upload: self.$upload, download: self.$selectedDownload, state: 2)
        }
    }
}

struct DownloadView_Previews: PreviewProvider {
    static var previews: some View {
        DownloadView()
    }
}
