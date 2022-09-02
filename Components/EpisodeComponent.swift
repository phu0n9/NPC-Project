//
//  EpisodeComponent.swift
//  NPC
//
//  Created by Le Nguyen on 02/09/2022.
//

import SwiftUI

struct EpisodeComponent: View {
    var body: some View {
//        ScrollView{
//            LazyVStack{
//                ForEach(0 ... 20, id: \.self) { _ in
//                    Text("episode row view")
//                }
//            }
//        }
        
        VStack {
            // podcast cover img, info
            HStack(alignment: .top, spacing: 12) {
                Circle()
                    .frame(width: 56, height: 56)
                    .foregroundColor(Color.orange)
                    .padding(0)
                
                VStack {
                    Text("Episode Ttitle here")
                        .font(.subheadline).bold()
                    Text("uploaded date here")
                            .font(.caption)
                }
            }
            Text("description will be here.description will be here.description will be heredescription will be here.")
                .multilineTextAlignment(.leading)
            Divider()
        }
    }
}

struct EpisodeComponent_Previews: PreviewProvider {
    static var previews: some View {
        EpisodeComponent()
    }
}
