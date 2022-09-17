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
    @ObservedObject var soundControl = SoundControl()
    @Binding var isTapped: Bool
    
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
            
            ZStack {
                Button(action: {
                    withAnimation(.default) {
                        self.download.isTapped.toggle()
                    }
                }, label: {
                    Image(systemName: self.soundControl.isActive ?  "play.fill" : "pause.fill")
                        .renderingMode(.template)
                        .foregroundColor(.orange)
                        .frame(width:13, height: 6, alignment: .leading)
                        .padding(5)
                    Text("Play me")
                        .font(.caption)
                        .foregroundColor(.black)
                        .padding(9)
                })
            }
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color(red: 1, green: 0.4902, blue: 0.3216), lineWidth: 1))
            
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
