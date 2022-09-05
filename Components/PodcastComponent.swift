//
//  podcastOnTrendingView.swift
//  NPC
//
//  Created by Le Nguyen on 03/09/2022.
//

import SwiftUI

struct PodcastComponent: View {
    var title: String
    var image: String
    var author: String
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: self.image)) { podcastImage in
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
                Text(self.title)
                    .font(.title3)
                    .frame(alignment: .leading)
            }.padding(0)
            Text(self.author)
                .font(.caption)
                .foregroundColor(.gray)
                .frame(alignment: .leading)
        }.padding(0)
    }
}

struct PodcastComponent_Previews: PreviewProvider {
    static var previews: some View {
        PodcastComponent(title: "Title", image: "add-list-icon", author: "Author")
    }
}
