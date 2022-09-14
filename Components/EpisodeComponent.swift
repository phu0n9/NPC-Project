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
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // MARK: podcast episode info
            HStack(alignment: .top, spacing: 20) {
                
                // MARK: podcast image
                AsyncImage(url: URL(string: self.episode.image)) { podcastImage in
                    podcastImage
                        .resizable()
                        .font(.title)
                        .frame(width: 70, height: 70)
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
                        Text(self.episode.title)
                            .font(.subheadline).bold()
                    }
                    // MARK: publish date
                    Text(self.episode.pub_date)
                        .font(.caption)
                }
            }.padding()
            
            // MARK: description
            Text(self.episode.description)
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
                PlayButton(length: Binding.constant(self.episode.audio_length), episode: $episode, soundName: self.episode.audio)
            }
            Divider()
        }
        .padding()
    }
}

struct EpisodeComponent_Previews: PreviewProvider {
    static var previews: some View {
        EpisodeComponent(episode: Binding.constant(Episodes(audio: "", audio_length: 0, description: "", episode_uuid: "", podcast_uuid: "", pub_date: "", title: "", image: "", user_id: "", isLiked: false)), isExpanded: Binding.constant(false))
    }
}
