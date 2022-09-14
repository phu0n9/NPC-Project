//
//  CommunityStreamView.swift
//  NPC
//
//  Created by Nguyen Huynh Phuong Anh on 14/09/2022.
//

import SwiftUI

struct CommunityStreamView: View {
    @State var episode: Episodes = Episodes(audio: "", audio_length: 0, description: "", episode_uuid: "", podcast_uuid: "", pub_date: "", title: "", image: "", user_id: "", isLiked: false)
    @StateObject var uploadViewModel = UploadViewModel()
    @State var time = Timer.publish(every: 0.1, on: .main, in: .tracking).autoconnect()

    var body: some View {
        ScrollView {
            ForEach(self.$uploadViewModel.uploads, id: \.id) { $value in
                ZStack {
                    if self.uploadViewModel.uploads.last?.id == value.id {
                        GeometryReader { bounds in
                            VStack(alignment: .center) {
                                ProgressView()
                            }
                            .onAppear {
                                self.time = Timer.publish(every: 0.1, on: .main, in: .tracking).autoconnect()
                            }
                            .onReceive(self.time) { (_) in
//                                    if bounds.frame(in: .global).maxY < UIScreen.main.bounds.height - 80 {
//                                        self.uploadViewModel.fetchUploads()
//                                    }
                                print(bounds.frame(in: .global).maxY)
                                self.time.upstream.connect().cancel()
                            }
                        }
                        .frame(height: UIScreen.main.bounds.height)
                    } else {
                        StreamingView(episode: self.$episode, upload: $value, state: 1)
                        Divider()
                            .frame(height: 1)
                            .padding(.horizontal, 30)
                            .background(Color.black)
                    }
                }
            }
        }
        .onAppear {
            DispatchQueue.main.async {
                self.uploadViewModel.fetchUploads()
            }
        }
    }
}

struct CommunityStreamView_Previews: PreviewProvider {
    static var previews: some View {
        CommunityStreamView()
    }
}
