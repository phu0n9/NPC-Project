//
//  EpisodeComponent.swift
//  NPC
//
//  Created by Le Nguyen on 02/09/2022.
//

import SwiftUI

struct EpisodeComponent: View {
    var body: some View {

        
        VStack(alignment: .leading,spacing: 10) {
            // podcast cover img, info
            HStack(alignment: .top, spacing: 20) {
                Circle()
                    .frame(width: 56, height: 56)
                    .foregroundColor(Color.orange)
                    .padding(0)
                
                VStack(alignment: .leading, spacing: 10){
                    HStack {
                        Text("Episode Ttitle here")
                            .font(.subheadline).bold()
                    }
                    Text("date here")
                            .font(.caption)

                }
            }.padding()
            Text("description will be here.")
                .multilineTextAlignment(.center)
            
            HStack(alignment: .top, spacing: 0){
                PlayButton()
            }
            Divider()
        }.padding()
    }
}

struct EpisodeComponent_Previews: PreviewProvider {
    static var previews: some View {
        EpisodeComponent()
    }
}
