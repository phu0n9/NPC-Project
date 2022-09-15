//
//  CastingView.swift
//  NPC
//
//  Created by Le Nguyen on 02/09/2022.
//

import SwiftUI

struct CastingView: View {
    @State var currentTab: Int
    @State var episode = Episodes(audio: "", audio_length: 0, description: "", episode_uuid: "", podcast_uuid: "", pub_date: "", title: "", image: "", user_id: "", isLiked: false)
    let titleTab = [0: "Community", 1: "Your Cast"]
    
    var body: some View {
        VStack {
            TabBarView(currentTab: self.$currentTab, state: 1)
            TabView(selection: self.$currentTab) {
                CommunityStreamView().tag(0)
                UserCastingView().tag(1)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
    }
}

struct CastingView_Previews: PreviewProvider {
    static var previews: some View {
        CastingView(currentTab: 0)
    }
}
