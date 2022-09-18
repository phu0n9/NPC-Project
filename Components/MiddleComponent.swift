//
//  MiddleComponent.swift
//  NPC
//
//  Created by Sang Yeob Han  on 15/09/2022.
//

import SwiftUI

struct MiddleComponent: View {
    
    var podcast: Podcasts
    @State private var isTapped : Bool = false
    
    var body: some View {
            VStack {
                NavigationLink("", destination: PodcastDetailView(podcast: podcast), isActive: self.$isTapped)
                AsyncImage(url: URL(string: self.podcast.image)) { podcastImage in
                    podcastImage
                        .resizable()
                        .font(.title)
                        .frame(width: 160, height: 120, alignment: .leading)
                        .foregroundColor(.orange)
                        .cornerRadius(5)
                        
                } placeholder: {
                    ProgressView()
                }
                HStack(alignment: .firstTextBaseline, spacing: 10) {
                    Text(self.podcast.title)
                        .font(.headline)
                        .frame(maxWidth: 200, alignment: .leading)
                }.padding(0)
            }
            .onTapGesture {
                self.isTapped.toggle()
            }
            .padding(0)
        }
    
}

struct MiddleComponent_Previews: PreviewProvider {
    static var previews: some View {
        MiddleComponent(podcast: Podcasts(uuid: "", author: "", description: "", image: "", itunes_id: 23, language: "", title: "", website: "", categories: ["Technology", "Arts"], episodes: []))
    }
}
