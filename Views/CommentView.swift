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
// MARK: show list of comments based on a user upload
struct CommentView: View {
    var upload: Uploads
    @State var content = ""
    @ObservedObject var userSettings = UserSettings()
    @ObservedObject var uploadViewModel = UploadViewModel()
    @State var isSubmit = false
    @State var isDeleted = false
    
    var body: some View {
        ZStack {
            if self.isSubmit || self.isDeleted {
                TransitionView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            if self.isSubmit {
                                self.isSubmit.toggle()
                            }
                            if self.isDeleted {
                                self.isDeleted.toggle()
                            }
                        }
                    }
            } else {
                VStack {
                    Text("\(self.uploadViewModel.commentList.count) comment")
                        .font(Font.title2.weight(.semibold))
                        .padding()
                    ScrollView {
                        ForEach(self.$uploadViewModel.commentList, id: \.id) { $value in
                            CommentItem(comment: $value, uploadID: self.upload.uuid, isDeleted: self.$isDeleted)
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
                                        self.isSubmit.toggle()
                                        self.content = ""
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
                    }
                }
            }
        }
    }
}

// struct CommentView_Previews: PreviewProvider {
//    static var previews: some View {
//        CommentView()
//    }
// }
