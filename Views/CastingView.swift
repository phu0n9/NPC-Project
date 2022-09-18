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

// MARK: user community podcast and list of their own podcasts
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
