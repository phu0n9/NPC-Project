//
//  UserUploadComponent.swift
//  NPC
//
//  Created by Sang Yeob Han  on 16/09/2022.
//

import SwiftUI

struct UserUploadComponent: View {
    
    @ObservedObject var uploadViewModel = UploadViewModel()
    @ObservedObject var uploadControl = UploadControl()
    @Binding var upload : Uploads
    
    var body: some View {
        VStack {
            HStack {
                // MARK: upload image
                AsyncImage(url: URL(string: self.upload.image)) { uploadImage in
                    uploadImage
                        .resizable()
                        .font(.title)
                        .frame(width: 40, height: 40)
                        .clipShape(Rectangle())
                        .foregroundColor(.orange)
                        .cornerRadius(10)
                        .padding(0)
                } placeholder: {
                    ProgressView()
                }
                
                VStack {
                    // MARK: title
                    Text(self.upload.title)
                        .font(.system(size: 14))
                        .lineLimit(1)
                    
                    // MARK: publish date
                    Text(self.upload.pub_date)
                        .font(.system(size: 10))
                        .foregroundColor(.gray)
                }.padding()
                Spacer()
                
            }.padding(0)
            
            HStack {
                UserUploadButton(isTapped: Binding.constant(false), upload: self.$upload)
            }
            .padding(0)
            Divider()
            
        }.padding(0)
    }
}

struct UserUploadComponent_Previews: PreviewProvider {
    static var previews: some View {
        UserUploadComponent(upload: Binding.constant(Uploads(title: "", description: "", audioPath: "", author: "", pub_date: "", image: "", userID: "", numOfLikes: 0, audio_length: 0, userImage: "", likes: [], comments: [])))
    }
}
