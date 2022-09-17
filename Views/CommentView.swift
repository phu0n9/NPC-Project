//
//  CommentView.swift
//  NPC
//
//  Created by Nguyen Huynh Phuong Anh on 14/09/2022.
//

import SwiftUI

struct CommentView: View {
    var upload: Uploads
    @State var content = ""
    @ObservedObject var userSettings = UserSettings()
    @ObservedObject var uploadViewModel = UploadViewModel()
    
    var body: some View {
        VStack {
            Text("\(self.uploadViewModel.commentList.count) people comment on this.")
                .font(Font.title3.weight(.light))
                .padding()
            ScrollView {
                ForEach(self.$uploadViewModel.commentList, id: \.id) { $value in
                    CommentItem(comment: $value, uploadID: self.upload.uuid)
                }
            }
            Spacer()
            
            Capsule()
            /* #f5f5f5 */
                .foregroundColor(Color(red: 0.9608, green: 0.9608, blue: 0.9608))
                .frame(width: UIScreen.main.bounds.width-30, height: 50)
            
                .overlay(
                    HStack {
                        TextField("Comment something about this", text: self.$content)
                            .offset(x: 30, y: 0)
                        Spacer()
                        Button(action: {
                            DispatchQueue.main.async {
                                let randomID = UUID().uuidString
                                self.uploadViewModel.comment = Comments(uuid: randomID, author: self.userSettings.username, userID: self.userSettings.uuid, content: self.content, image: self.userSettings.userImage)
                                self.uploadViewModel.addComments(uploadID: self.upload.uuid, comment: self.uploadViewModel.comment)
                            }
                        }, label: {
                            Image(systemName: "paperplane")
                                .frame(width: 40, height: 40)
                                .padding()
                        })
                    }
                )
                .padding(6)
                .autocapitalization(.none)
            
        }
        .onAppear {
            DispatchQueue.main.async {
                self.uploadViewModel.fetchCommentsByUploadID(uploadID: self.upload.uuid)
                print(self.uploadViewModel.upload.comments.count)
            }
        }
    }
}

// struct CommentView_Previews: PreviewProvider {
//    static var previews: some View {
//        CommentView()
//    }
// }
