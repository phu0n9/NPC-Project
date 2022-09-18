/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2022B
  Assessment: Assignment 3
  Authors:
    Nguyen Huynh Anh Phuong - s3695662
    Le Nguyen - s3777242
    Han Sangyeob - s3821179
    Nguyen Anh Minh - s3911237
  Created  date: 29/08/2022
  Last modified: 18/09/2022
  Acknowledgments: StackOverflow, Youtube, and Mr. Tom Huynh’s slides
*/

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
