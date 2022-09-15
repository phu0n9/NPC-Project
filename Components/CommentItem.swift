//
//  CommentItem.swift
//  NPC
//
//  Created by Nguyen Huynh Phuong Anh on 14/09/2022.
//

import SwiftUI

struct CommentItem: View {
    @Binding var comment: Comments
    var uploadID : String
    @ObservedObject private var userSettings = UserSettings()
    @StateObject var uploadViewModel = UploadViewModel()
    
    var body: some View {
        HStack {
            if self.comment.image == "" {
                Image(systemName: "person")
                    .resizable()
                    .font(.title)
                    .frame(width: 30, height: 30, alignment: .leading)
                    .foregroundColor(.orange)
                    .cornerRadius(20)
            } else {
                AsyncImage(url: URL(string: self.comment.image)) { commentImage in
                    commentImage
                        .resizable()
                        .font(.title)
                        .frame(width: 30, height: 30, alignment: .leading)
                        .foregroundColor(.orange)
                        .cornerRadius(20)
                } placeholder: {
                    ProgressView()
                }
                .padding()
            }
            
            VStack(alignment: .leading) {
                HStack(alignment: .firstTextBaseline, spacing: 10) {
                    Text(self.comment.author)
                        .font(.title3)
                        .frame(maxWidth: 100, alignment: .leading)
                }
                
                Text(self.comment.content)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .frame(maxWidth: 100, alignment: .leading)
                
                if self.userSettings.uuid == self.comment.userID {
                    Button(action: {
                        self.uploadViewModel.deleteComments(uploadID: self.uploadID, commentID: self.comment.uuid)
                    }, label: {
                        Text("Delete")
                            .font(.body)
                            .frame(maxWidth: 100, alignment: .leading)
                            .foregroundColor(Color.red)
                    })
                }
            }
            .frame(width: 300)
        }
    }
}

struct CommentItem_Previews: PreviewProvider {
    static var previews: some View {
        CommentItem(comment: .constant(Comments(uuid: "", author: "Phuong", userID: "", content: "this is comment", image: "")), uploadID: "")
    }
}
