//
//  CastingView.swift
//  NPC
//
//  Created by Le Nguyen on 02/09/2022.
//

import SwiftUI

struct CastingView: View {
    @State var currentTab: Int = 0
    @State var episode = Episodes(audio: "", audio_length: 0, description: "", episode_uuid: "", podcast_uuid: "", pub_date: "", title: "", image: "", user_id: "", isLiked: false)
    @State var upload = Uploads(title: "", description: "", audioPath: "", author: "", pub_date: "", image: "", userID: "", numOfLikes: 0, audio_length: 0, likes: [], comments: [])
    let titleTab = [0: "Community", 1: "Your Cast"]
    
    var body: some View {
        VStack {
            TabBarView(currentTab: self.$currentTab)
            TabView(selection: self.$currentTab) {
                StreamingView(episode: self.$episode, upload: self.$upload, state: 1).tag(0)
                UserCastingView().tag(1)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
    }
}

struct CastingView_Previews: PreviewProvider {
    static var previews: some View {
        CastingView()
    }
}
