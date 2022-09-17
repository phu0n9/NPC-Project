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
    @State var episode = Episodes(audio: "", audio_length: 0, description: "", episode_uuid: "", podcast_uuid: "", pub_date: "", title: "", image: "", user_id: "", isLiked: false)
   
    @State var isCommentTapped: Bool = false
    @Binding var isTapped: Bool
    @Binding var upload : Uploads
    
    var body: some View {
        
        HStack {
            ZStack {
                Button(action: {
                    withAnimation(.default) {
                        self.isTapped.toggle()
                        self.soundControl.playSound(soundName: self.upload.audioPath, isLocalFile: false)
                    }
                }, label: {
                    Image(systemName: self.soundControl.isActive ?  "play.fill" : "pause.fill")
                        .renderingMode(.template)
                        .foregroundColor(.orange)
                        .frame(width:13, height: 6, alignment: .leading)
                        .padding(5)
                    Text(String(self.upload.audio_length))
                        .font(.caption)
                        .foregroundColor(.black)
                        .padding(9)
                })
            }
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color(red: 1, green: 0.4902, blue: 0.3216), lineWidth: 1)
            )
            .padding()
            
            // MARK: heart icon
            Button(action: {

            }, label: {
                Image(systemName: "heart")
                    .renderingMode(.template)
                    .foregroundColor(.orange)
                    .frame(width:20, height: 30, alignment: .leading)
                    .padding(5)
            }).padding(5)
                        
            Text(String(self.upload.numOfLikes))
                .font(.system(size:10))
                .padding(0)
            
            Button(action: {
                self.isCommentTapped = true
            }, label: {
                Image(systemName:"ellipsis.bubble")
                    .renderingMode(.template)
                    .foregroundColor(.orange)
                    .frame(width:20, height: 30, alignment: .leading)
                    .padding(5)
            })
            
            Text("\(self.uploadViewModel.commentList.count)")
                .font(.system(size:10))
            
        }
        .padding(5)
        .sheet(isPresented: self.$isCommentTapped) {
            CommentView(upload: self.upload)
        }
    }
}

struct UserUploadButton_Previews: PreviewProvider {
    static var previews: some View {
        UserUploadButton(isTapped: Binding.constant(false), upload: Binding.constant(Uploads(title: "", description: "", audioPath: "", author: "", pub_date: "", image: "", userID: "", numOfLikes: 0, audio_length: 0, userImage: "", likes: [], comments: [])))

    }
}
