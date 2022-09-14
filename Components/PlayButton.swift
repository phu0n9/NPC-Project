//
//  PlayButton.swift
//  NPC
//
//  Created by Le Nguyen on 03/09/2022.
//

import SwiftUI
import SimpleToast

struct PlayButton: View {
    
    @State private var isDownload = 0
    @ObservedObject var soundControl = SoundControl()
    @ObservedObject private var userViewModel = UserViewModel()
    @Binding var length:Int
    @Binding var episode : Episodes
    var soundName: String

    var body: some View {
        HStack {
            VStack(spacing:10) {
                Button(action: {
                    self.soundControl.playSound(soundName: soundName, isPreview: true)
                }, label: {
                    Image(systemName: self.soundControl.isActive ?  "play.fill" : "pause.fill")
                        .renderingMode(.template)
                        .foregroundColor(.orange)
                        .frame(width:13, height: 6, alignment: .leading)
                        .padding(5)
                    Text(String(self.length))
                        .font(.caption)
                        .foregroundColor(.black)
                        .padding(9)
                })
            }
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(red: 1, green: 0.4902, blue: 0.3216), lineWidth: 1))
                    
            // MARK: heart icon
            Button(action: {
                self.episode.isLiked.toggle()
                self.userViewModel.addFavorite(favorite: episode)
            }, label: {
                Image(systemName: self.episode.isLiked ? "heart.fill" : "heart")
                    .renderingMode(.template)
                    .foregroundColor(.orange)
                    .frame(width:20, height: 20, alignment: .leading)
                    .padding()
            }).padding(0)
        }
        .padding(0)
            
}
    

struct PlayButton_Previews: PreviewProvider {
    static var previews: some View {
        PlayButton(length:Binding.constant(0), episode: Binding.constant(Episodes(audio: "", audio_length: 0, description: "", episode_uuid: "", podcast_uuid: "", pub_date: "", title: "", image: "", user_id: "", isLiked: false)), soundName: "sound link")
    }
}
}
