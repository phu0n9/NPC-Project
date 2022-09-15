//
//  podcastOnTrendingView.swift
//  NPC
//
//  Created by Le Nguyen on 03/09/2022.
//

import SwiftUI

struct PodcastComponent: View {
    var podcast: Podcasts
    @State private var isTapped : Bool = false
    var body: some View {
        VStack {
            NavigationLink("", destination: PodcastDetailView(podcast: podcast), isActive: self.$isTapped)
            AsyncImage(url: URL(string: self.podcast.image)) { podcastImage in
                podcastImage
                    .resizable()
                    .font(.title)
                    .frame(width: 90, height: 90, alignment: .leading)
                    .foregroundColor(.orange)
                    .cornerRadius(20)
            } placeholder: {
                ProgressView()
            }
            HStack(alignment: .firstTextBaseline, spacing: 10) {
                Text(self.podcast.title)
                    .font(.caption)
                    .frame(maxWidth: 100, alignment: .leading)
            }.padding(0)
            Text(self.podcast.author)
                .font(.caption2)
                .foregroundColor(.gray)
                .frame(maxWidth: 100, alignment: .leading)
        }
        .onTapGesture {
            self.isTapped.toggle()
        }
        .padding(0)
    }
}

struct PodcastComponent_Previews: PreviewProvider {
    static var previews: some View {
        PodcastComponent(podcast: Podcasts(uuid: "", author: "", description: "", image: "", itunes_id: 23, language: "", title: "", website: "", categories: ["Technology", "Arts"], episodes: []))
    }
}
