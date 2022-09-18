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

// MARK: download view showing list of downloaded episodes
struct DownloadView: View {
    @StateObject var downloadControl: DownloadControl = DownloadControl()
    @State var isTapped = false
    @State var download = Downloads(audio: "", title: "", isProcessing: false)
    @State private var episode = Episodes(audio: "", audio_length: 0, description: "", episode_uuid: "", podcast_uuid: "", pub_date: "", title: "", image: "", user_id: "", isLiked: false)
    @State private var upload = Uploads(title: "", description: "", audioPath: "", author: "", pub_date: "", image: "", userID: "", numOfLikes: 0, audio_length: 0, userImage: "", likes: [], comments: [])
    
    var body: some View {
        ScrollView {
            if self.downloadControl.downloads.isEmpty {
                EmptyListView(title: "Download List")
            } else {
                 ScrollView {
                    LazyVStack {
                        ForEach(self.$downloadControl.downloads, id: \.id) { $download in
                            // return original data
                            DownloadItem(download: $download, isTapped: self.$isTapped)
                                .onTapGesture {
                                    download.isTapped.toggle()
                                }
                                .onChange(of: download.isTapped) { value in
                                    if value {
                                        self.download = download
                                        self.isTapped.toggle()
                                    }
                                }
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
            StreamingView(episode: self.$episode, upload: self.$upload, download: self.$download, state: 2)
        }
    }
}

struct DownloadView_Previews: PreviewProvider {
    static var previews: some View {
        DownloadView()
    }
}
