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

struct UserUploadComponent: View {
    
    @ObservedObject var uploadViewModel = UploadViewModel()
    @ObservedObject var uploadControl = UploadControl()
    @Binding var upload : Uploads
    
    var body: some View {
        VStack {
            HStack(spacing:30) {
                // MARK: upload image
                AsyncImage(url: URL(string: self.upload.image)) { uploadImage in
                    uploadImage
                        .resizable()
                        .font(.title)
                        .frame(width: 60, height: 60)
                        .clipShape(Rectangle())
                        .cornerRadius(10)
                        .padding(5)
                    
                } placeholder: {
                    ProgressView()
                }
                
                VStack(alignment: .leading) {
                    // MARK: title
                    Text(self.upload.title)
                        .font(.system(size: 17))
                        .lineLimit(1)
                        .padding(0)
                    
                    // MARK: publish date
                    Text(self.upload.pub_date)
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                        .padding(0)
                }.padding(0)
                
                Spacer()
                
            }.padding(5)
            
            HStack {
                UserUploadButton(upload: self.$upload)
                    .padding(.leading)
                    .frame(width: 400, height: 50, alignment: .leading)
            }
            .padding(0)
            Divider()
            
        }.padding(5)
    }
}

struct UserUploadComponent_Previews: PreviewProvider {
    static var previews: some View {
        UserUploadComponent(upload: Binding.constant(Uploads(title: "123", description: "123", audioPath: "123", author: "123", pub_date: "123", image: "https://firebasestorage.googleapis.com:443/v0/b/npc-project-742bd.appspot.com/o/recording_images%2F828CDA00-36E7-4FE1-A8FB-3E7D5E7648AF.jpg?alt=media&token=aa81f16a-97c7-4714-9725-e1f68a4ea608", userID: "123", numOfLikes: 0, audio_length: 123, userImage: "", likes: [], comments: [])))
    }
}
