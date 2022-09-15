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
    @State private var currentUpload = ""
    
    @ViewBuilder
    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            TabView(selection: self.$currentUpload) {
                ForEach(self.$uploadViewModel.uploads, id: \.id) { $value in
                    StreamingView(episode: self.$episode, upload: $value, state: 1)
                        .frame(width: size.width)
                        .padding()
                        .rotationEffect(.init(degrees: -90))
                        .tag(value.id)
                }
            }
            .rotationEffect(.init(degrees: 90))
            .frame(width: size.height)
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(width: size.width)
            .onChange(of: self.currentUpload) { value in
                if value == self.uploadViewModel.uploads.last?.id {
                    self.uploadViewModel.fetchUploads()
                }
            }
        }
        .onAppear {
            DispatchQueue.main.async {
                self.uploadViewModel.fetchUploads()
                if let currentUploadID = self.uploadViewModel.uploads.first?.id {
                    self.currentUpload = currentUploadID
                }
            }
        }
    }
}

struct CommunityStreamView_Previews: PreviewProvider {
    static var previews: some View {
        CommunityStreamView()
    }
}
