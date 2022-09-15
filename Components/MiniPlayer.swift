//
//  MiniPlayer.swift
//  NPC
//
//  Created by Nguyen Huynh Phuong Anh on 13/09/2022.
//

import SwiftUI

struct MiniPlayer: View {
    @Binding var episode: Episodes
    @Binding var author: String
    
    var body: some View {
        VStack {
            HStack {
                AsyncImage(url: URL(string: self.episode.image)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 60, height: 32)
                        .clipShape(Circle())
                } placeholder: {
                    ProgressView()
                }
                
                VStack {
                    Text(self.episode.title)
                        .font(.caption)
                        .fontWeight(.heavy)
                        .foregroundColor(.black)
                        .lineLimit(1)
                        .frame(alignment: .trailing)
                    
                    Text(self.author)
                        .font(.caption2)
                        .foregroundColor(.gray)
                        .lineLimit(1)
                    
                }.padding()
                
                Image(systemName: "play.fill")
                    .resizable()
                    .frame(width: 20, height: 20)
            }
        }
        .frame(height: 80)
        .offset(y: -48)
    }
}

struct MiniPlayer_Previews: PreviewProvider {
    static var previews: some View {
        MiniPlayer(episode: .constant(Episodes(audio: "", audio_length: 0, description: "", episode_uuid: "", podcast_uuid: "", pub_date: "", title: "title name", image: "", user_id: "", isLiked: false)), author: .constant("author name"))
    }
}
