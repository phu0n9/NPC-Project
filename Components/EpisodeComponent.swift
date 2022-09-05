//
//  EpisodeComponent.swift
//  NPC
//
//  Created by Le Nguyen on 02/09/2022.
//

import SwiftUI

struct EpisodeComponent: View {
    var title: String
    var pub_date: String
    var description: String
    var audio: String
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 10) {
            // podcast cover img, info
            HStack(alignment: .top, spacing: 20) {
                Circle()
                    .frame(width: 56, height: 56)
                    .foregroundColor(Color.orange)
                    .padding(0)
                
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text(self.title)
                            .font(.subheadline).bold()
                    }
                    Text(self.pub_date)
                            .font(.caption)
                }
            }.padding()
            Text(self.description)
                .multilineTextAlignment(.center)
            
            HStack(alignment: .top, spacing: 0) {
                PlayButton(soundName: self.audio)
            }
            Divider()
        }.padding()
    }
}

struct EpisodeComponent_Previews: PreviewProvider {
    static var previews: some View {
        EpisodeComponent(title: "Title", pub_date: "2022/09/09", description: "Description", audio: "a link")
    }
}
