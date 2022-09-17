//
//  EpisodeComponent.swift
//  NPC
//
//  Created by Le Nguyen on 02/09/2022.
//

import SwiftUI

struct EpisodeComponent: View {
    @Binding var episode: Episodes
    @Binding var isExpanded: Bool
    @Binding var isTapped: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // MARK: podcast episode info
            HStack(alignment: .top, spacing: 20) {
                
                // MARK: podcast image
                AsyncImage(url: URL(string: self.episode.image)) { podcastImage in
                    podcastImage
                        .resizable()
                        .font(.title)
                        .frame(width: 40, height: 40)
                        .clipShape(Rectangle())
                        .foregroundColor(.orange)
                        .cornerRadius(10)
                        .padding(0)
                } placeholder: {
                    ProgressView()
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        // MARK: title
                        Text(self.episode.title)
                            .font(.system(size: 14))
                            .lineLimit(1)
                    }
                    // MARK: publish date
                    Text(self.episode.pub_date)
                        .font(.system(size: 10))
                }
            }.padding(0)
            
            // MARK: description
            Text(self.episode.description)
                .font(.system(size: 13))
                .lineLimit(isExpanded ? nil : 1)
                .overlay(
                    GeometryReader { proxy in
                        Button(action: {
                            isExpanded.toggle()
                        }, label: {
                            Text(isExpanded ? "Less" : "More")
                                .font(.system(size: 12))
                                .padding(.leading, 8.0)
                                .padding(.top, 4.0)
                                .background(Color.white)
                        })
                        .frame(width: proxy.size.width, height: abs(proxy.size.height), alignment: .bottomTrailing)
                    }
                )
            
            HStack(alignment: .top, spacing: 0) {
                PlayButton(length: Binding.constant(self.episode.audio_length), episode: $episode, soundName: self.episode.audio, isTapped: $isTapped)
            }
            Divider()
        }
        .padding()
    }
}

struct EpisodeComponent_Previews: PreviewProvider {
    static var previews: some View {
        EpisodeComponent(episode: Binding.constant(Episodes(audio: "", audio_length: 0, description: "", episode_uuid: "", podcast_uuid: "", pub_date: "", title: "", image: "", user_id: "", isLiked: false)), isExpanded: Binding.constant(false), isTapped: Binding.constant(false))
    }
}
