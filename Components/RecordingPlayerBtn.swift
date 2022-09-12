//
//  RecordingPlayer.swift
//  NPC
//
//  Created by Nguyen Huynh Phuong Anh on 12/09/2022.
//

import SwiftUI

struct RecordingPlayerBtn: View {
    @ObservedObject var soundControl = SoundControl()
    var soundName: String
    @Binding var isDeleted: Bool
    
    var body: some View {
        Button(action: {
            self.soundControl.playSound(soundName: soundName, isPreview: false)
        }, label: {
            Image(self.soundControl.isActive ? "play-circle-icon" : "pause-circle-icon")
                .renderingMode(.template)
                .foregroundColor(.orange)
                .frame(width:15, height: 6, alignment: .leading)
                .padding(5)
            Text(soundName)
                .font(.caption)
                .foregroundColor(.black)
                .padding(9)
            Button(action: {
                self.isDeleted.toggle()
            }, label: {
                Image(systemName: "x.square.fill")
                    .renderingMode(.template)
                    .foregroundColor(.orange)
                    .frame(width:30, height: 15, alignment: .trailing)
                    .padding(5)
            })
        })
        .overlay(
            RoundedRectangle(cornerRadius: 5)
                .fill(Color.orange.opacity(0.05))
                .allowsHitTesting(false)
                .addBorder(Color.orange, width: 2, cornerRadius: 5)
        )
    }
}

struct RecordingPlayer_Previews: PreviewProvider {
    static var previews: some View {
        RecordingPlayerBtn(soundName: "", isDeleted: Binding.constant(false))
    }
}
