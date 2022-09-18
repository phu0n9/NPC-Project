//
//  UserUploadButton.swift
//  NPC
//
//  Created by Sang Yeob Han  on 16/09/2022.
//

import SwiftUI

struct UserUploadButton: View {
    
    @ObservedObject var uploadViewModel = UploadViewModel()
    @ObservedObject var userSettings = UserSettings()
    @ObservedObject var soundControl = SoundControl()
    @State var isCommentTapped: Bool = false
    @Binding var upload : Uploads
    
    var body: some View {
        
        HStack {
            ZStack {
                Button(action: {
                    withAnimation(.default) {
                        self.upload.isTapped.toggle()
                        self.soundControl.playSound(soundName: self.upload.audioPath, isLocalFile: false)
                    }
                }, label: {
                    Image(systemName: self.soundControl.isActive ?  "play.fill" : "pause.fill")
                        .renderingMode(.template)
                        .foregroundColor(.orange)
                        .frame(width:13, height: 6, alignment: .leading)
                        .padding(5)
                    Text("\(self.upload.audio_length)s")
                        .font(.caption)
                        .foregroundColor(.black)
                        .padding(9)
                })
            }
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color(red: 1, green: 0.4902, blue: 0.3216), lineWidth: 1)
            )
            .padding(5)
            
            // MARK: heart icon
            Button(action: {

            }, label: {
                Image(systemName: "heart")
                    .renderingMode(.template)
                    .foregroundColor(.orange)
                    .frame(width:20, height: 30, alignment: .leading)
                
            })
                        
            Text(String(self.upload.numOfLikes))
                .font(.system(size:10))

            Button(action: {
                self.isCommentTapped = true
            }, label: {
                Image(systemName:"ellipsis.bubble")
                    .renderingMode(.template)
                    .foregroundColor(.orange)
                    .frame(width:20, height: 30, alignment: .leading)
                    
            })
            
            Text("\(self.upload.comments.count)")
                .font(.system(size:10))
        }
        .padding(2)
        .sheet(isPresented: self.$isCommentTapped) {
            CommentView(upload: self.upload)
        }
    }
}

struct UserUploadButton_Previews: PreviewProvider {
    static var previews: some View {
        UserUploadButton(upload: Binding.constant(Uploads(title: "", description: "", audioPath: "", author: "", pub_date: "", image: "", userID: "", numOfLikes: 0, audio_length: 0, userImage: "", likes: [], comments: [])))

    }
}
