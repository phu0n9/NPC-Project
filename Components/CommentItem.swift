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

struct CommentItem: View {
    @Binding var comment: Comments
    var uploadID : String
    @ObservedObject private var userSettings = UserSettings()
    @StateObject var uploadViewModel = UploadViewModel()
    @Binding var isDeleted: Bool
    
    var body: some View {
        HStack {
            
            if self.comment.image == "" {
                Image(systemName: "person")
                    .resizable()
                    .font(.title)
                    .frame(width: 40, height: 40, alignment: .leading)
                    .foregroundColor(Color("MainButton"))
                    .cornerRadius(20)
                    .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color(.gray).opacity(0.5), lineWidth: 1)
                                   
                    )
                
            } else {
                AsyncImage(url: URL(string: self.comment.image)) { commentImage in
                    commentImage
                        .resizable()
                        .font(.title)
                        .frame(width: 30, height: 30, alignment: .leading)
                        .foregroundColor(Color("MainButton"))
                        .cornerRadius(20)
                } placeholder: {
                    ProgressView()
                }
                .padding(10)
            }
            
            VStack(alignment: .leading) {
                HStack(alignment: .firstTextBaseline, spacing: 10) {
                    Text(self.comment.author)
                        .font(.system(size:15))
                        .fontWeight(.semibold)
                        .frame(maxWidth: 200, alignment: .leading)
                }.padding(1)
                
                Text(self.comment.content)
                    .font(.system(size:18))
                    .frame(maxWidth: 250, alignment: .leading)
                    .padding(1)
                
                if self.userSettings.uuid == self.comment.userID {
                    Button(action: {
                        self.uploadViewModel.deleteComments(uploadID: self.uploadID, commentID: self.comment.uuid)
                        self.isDeleted.toggle()
                    }, label: {
                        Text("Delete")
                            .font(.caption)
                            .frame(maxWidth: 100, alignment: .leading)
                            .foregroundColor(Color.red)
                    })
                }
            }
            .frame(width: 300)
        }.padding(10)
    }
}

struct CommentItem_Previews: PreviewProvider {
    static var previews: some View {
        CommentItem(comment: .constant(Comments(uuid: "", author: "Phuong", userID: "", content: "this is comment", image: "")), uploadID: "", isDeleted: .constant(false))
    }
}
