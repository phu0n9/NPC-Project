//
//  CommentView.swift
//  NPC
//
//  Created by Nguyen Huynh Phuong Anh on 14/09/2022.
//

import SwiftUI

struct CommentView: View {
    @Binding var uploadID: String
    @StateObject var uploadViewModel = UploadViewModel()
    
    var body: some View {
        VStack {
            ForEach(self.$uploadViewModel.upload.comments, id: \.id) { $value in
                CommentItem(comment: $value)
            }
        }
        .onAppear {
            DispatchQueue.main.async {
                self.uploadViewModel.fetchCommentsByUploadID(uploadID: self.uploadID)
            }
        }
    }
}

struct CommentView_Previews: PreviewProvider {
    static var previews: some View {
        CommentView(uploadID: .constant(""))
    }
}
