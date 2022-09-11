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

    var body: some View {
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
        })    }
}

struct RecordingPlayer_Previews: PreviewProvider {
    static var previews: some View {
        RecordingPlayerBtn(soundName: "")
    }
}
