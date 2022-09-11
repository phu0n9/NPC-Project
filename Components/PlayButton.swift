//
//  PlayButton.swift
//  NPC
//
//  Created by Le Nguyen on 03/09/2022.
//

import SwiftUI

struct PlayButton: View {
    
    @State private var isDownload = 0
    @State private var isAddedToMyList = 0
    @ObservedObject var soundControl = SoundControl()
    var soundName: String
    
    var body: some View {
        HStack {
            VStack(spacing:10) {
                Button(action: {
                    self.soundControl.playSound(soundName: self.soundName)
                }, label: {
                    Image(self.soundControl.isActive ? "play-circle-icon" : "pause-circle-icon")
                        .renderingMode(.template)
                        .foregroundColor(.orange)
                        .frame(width:15, height: 6, alignment: .leading)
                        .padding(5)
                    Text("Length")
                        .font(.caption)
                        .foregroundColor(.black)
                        .padding(9)
                })
            }
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(red: 1, green: 0.4902, blue: 0.3216), lineWidth: 1))
            
            Button(action: {
                isAddedToMyList += 1
                print("addlist-button clicked")
            }, label: {
                if isAddedToMyList % 2 == 0 {
                    Image("add-list-icon")
                        .frame(width:20, height: 20, alignment: .leading)
                        .padding()
                } else {
                    Image("add-list-icon")
                        .renderingMode(.template)
                        .foregroundColor(.orange)
                        .frame(width:20, height: 20, alignment: .leading)
                        .padding()
                }
                
            })
            Image("download-icon")
                .resizable()
                .frame(width:20, height: 15, alignment: .leading)
        }.padding()
    }
}

struct PlayButton_Previews: PreviewProvider {
    static var previews: some View {
        PlayButton(soundName: "sound link")
    }
}
