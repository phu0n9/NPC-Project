//
//  EpisodeComponent.swift
//  NPC
//
//  Created by Le Nguyen on 02/09/2022.
//

import SwiftUI

struct EpisodeComponent: View {
    var episode_uuid: String
    var podcast_uuid: String
    var title: String
    var pub_date: String
    var description: String
    var audio: String
    var image: String
    @Binding var isExpanded: Bool
    @State private var isTapped: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            NavigationLink("", destination: StreamingView(podcast_uuid: self.podcast_uuid, episode_uuid: self.episode_uuid), isActive: self.$isTapped)
            // MARK: podcast episode info
            HStack(alignment: .top, spacing: 20) {
                
                // MARK: podcast image
                AsyncImage(url: URL(string: self.image)) { podcastImage in
                    podcastImage
                        .resizable()
                        .font(.title)
                        .frame(width: 56, height: 56)
                        .clipShape(Circle())
                        .foregroundColor(.orange)
                        .cornerRadius(20)
                        .padding(0)
                } placeholder: {
                    ProgressView()
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        // MARK: title
                        Text(self.title)
                            .font(.subheadline).bold()
                    }
                    // MARK: publish date
                    Text(self.pub_date)
                        .font(.caption)
                }
            }.padding()
            
            // MARK: description
            Text(self.description)
                .lineLimit(isExpanded ? nil : 3)
                .overlay(
                    GeometryReader { proxy in
                        Button(action: {
                            isExpanded.toggle()
                        }, label: {
                            Text(isExpanded ? "Less" : "More")
                                .font(.caption).bold()
                                .padding(.leading, 8.0)
                                .padding(.top, 4.0)
                                .background(Color.white)
                        })
                        .frame(width: proxy.size.width, height: abs(proxy.size.height), alignment: .bottomTrailing)
                    }
                )
            
            HStack(alignment: .top, spacing: 0) {
                PlayButton(soundName: self.audio)
            }
            Divider()
        }
        .padding()
        .onTapGesture {
            self.isTapped = true
        }
    }
}

struct EpisodeComponent_Previews: PreviewProvider {
    static var previews: some View {
        EpisodeComponent(episode_uuid: "6bf59a32de804ede9101f7ba75d12677", podcast_uuid: "0c28802a7e814a55ada3ba54847258bc", title: "Title", pub_date: "2022/09/09", description: "Description", audio: "a link", image: "", isExpanded: Binding.constant(false))
    }
}
