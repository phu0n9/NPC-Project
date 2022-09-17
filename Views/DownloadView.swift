//
//  DownloadView.swift
//  NPC
//
//  Created by Nguyen Huynh Phuong Anh on 16/09/2022.
//

import SwiftUI

struct DownloadView: View {
    @StateObject var downloadControl: DownloadControl = DownloadControl()
    
    var body: some View {
        ScrollView {
            if self.downloadControl.downloads.isEmpty {
                EmptyListView(title: "Download List")
            } else {
                 ScrollView {
                    LazyVStack {
                        ForEach(self.$downloadControl.downloads, id: \.id) { $download in
                            // return original data
                            DownloadItem(download: $download)
                        }
                    }
                }
            }
        }
        .onAppear {
            DispatchQueue.main.async {
                self.downloadControl.fetchAllDownloads()
            }
        }
    }
}

struct DownloadView_Previews: PreviewProvider {
    static var previews: some View {
        DownloadView()
    }
}
