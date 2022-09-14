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
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                ForEach(self.$uploadViewModel.uploads, id: \.id) { $value in
                    StreamingView(episode: self.$episode, upload: $value, state: 1)
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
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
