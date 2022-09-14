//
//  CommentItem.swift
//  NPC
//
//  Created by Nguyen Huynh Phuong Anh on 14/09/2022.
//

import SwiftUI

struct CommentItem: View {
    
    @Binding var comment: Comments
    
    var body: some View {
        HStack {
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
            
            VStack {
                HStack(alignment: .firstTextBaseline, spacing: 10) {
                    Text(self.comment.author)
                        .font(.title3)
                        .frame(maxWidth: 100, alignment: .leading)
                }.padding(0)
                Text(self.comment.content)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .frame(maxWidth: 100, alignment: .leading)
            }
        }
    }
}

struct CommentItem_Previews: PreviewProvider {
    static var previews: some View {
        CommentItem(comment: .constant(Comments(author: "Phuong", userID: "", content: "this is comment", image: "")))
    }
}
