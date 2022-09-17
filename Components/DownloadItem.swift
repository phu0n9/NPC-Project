//
//  DownloadItem.swift
//  NPC
//
//  Created by Nguyen Huynh Phuong Anh on 16/09/2022.
//

import SwiftUI

struct DownloadItem: View {
    @Binding var download: Downloads
    @ObservedObject var downloadControl = DownloadControl()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // MARK: downloaded episode info
            HStack(alignment: .top, spacing: 20) {
                
                // MARK: episode image
                Image(systemName: "music.note")
                    .resizable()
                    .font(.title)
                    .frame(width: 40, height: 40)
                    .clipShape(Rectangle())
                    .foregroundColor(.orange)
                    .cornerRadius(10)
                    .padding(0)
                
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        // MARK: title
                        Text(self.download.title)
                            .font(.system(size: 14))
                            .lineLimit(1)
                    }
                }
            }.padding(0)
            
            // MARK: Download
            Button(action: {
                DispatchQueue.main.async {
                    self.downloadControl.deleteFile(fileLocalName: self.download.title)
                }
            }, label: {
                Image(systemName: "arrow.down.square")
                    .renderingMode(.template)
                    .foregroundColor(.orange)
                    .frame(width:20, height: 30, alignment: .leading)
                    .padding(5)
            })
            .padding(0)
            Divider()
        }
        .padding()
        .onAppear {
            DispatchQueue.main.async {
                self.downloadControl.checkFileExists(fileLocalName: self.download.title)
            }
        }
    }
}

// struct DownloadItem_Previews: PreviewProvider {
//    static var previews: some View {
//        DownloadItem(download: .constant(Downloads(audio: "", title: "", image: "", isProcessing: false)))
//    }
// }
