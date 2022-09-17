//
//  UserCastingView.swift
//  NPC
//
//  Created by Nguyen Huynh Phuong Anh on 13/09/2022.
//

import SwiftUI

struct UserCastingView: View {
    
    @ObservedObject var uploadViewModel = UploadViewModel()
    @ObservedObject var userSettings = UserSettings()
    
    var body: some View {
        
        ScrollView {
            VStack {
                ForEach(self.$uploadViewModel.uploads, id: \.id) { $upload in
                    UserUploadComponent(upload: $upload)
                }
            }
        }
        .onAppear {
            DispatchQueue.main.async {
                self.uploadViewModel.fetchUploadsByUserId()
            }
        }
    }
}

struct UserCastingView_Previews: PreviewProvider {
    static var previews: some View {
        UserCastingView()
    }
}
