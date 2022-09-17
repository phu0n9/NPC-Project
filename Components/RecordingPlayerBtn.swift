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
    
        VStack {
            HStack(alignment:.firstTextBaseline, spacing: 0) {

                    Button(action : {
                        self.soundControl.playSound(soundName: self.soundName, isLocalFile: false)
                    },
                           label: {
                        Image(systemName: self.soundControl.isActive ? "play.fill" : "pause.fill")
                            .renderingMode(.template)
                            .foregroundColor(.black)
                            .frame( width:290, alignment: .bottomTrailing)
                            .padding(4)
                        
                    })
                    
                    Button(action: {
                            self.isDeleted.toggle()
                            
                        }, label: {
                            Spacer()
                            Text("Delete")
                                .background(.black)
                                .cornerRadius(5)
                                .foregroundColor(.white)
                                .padding(5)
                    })
                
                    Spacer()
                }
            
            Text("Your cast has been recorded successfully!")
                .padding(5)
                .lineLimit(1)
                .foregroundColor(.black)
        }.overlay(
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
