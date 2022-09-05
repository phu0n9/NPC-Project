//
//  TrendingView.swift
//  NPC
//
//  Created by Le Nguyen on 02/09/2022.
//

import SwiftUI

struct TrendingView: View {
    var body: some View {

      
        ScrollView{
            ScrollView(.horizontal) {
                HStack(spacing: 10) {
                    ForEach(0..<10, id: \.self) { _ in
                        ItemPodcast()
                    }
                }.padding()
        }

            Divider()
            Divider()
            
            ScrollView{
                LazyVStack{
                    ForEach(0 ... 20, id: \.self) { _ in
                        EpisodeComponent()
                    }
                }
            }
        }
        
        
    }
}

struct TrendingView_Previews: PreviewProvider {
    static var previews: some View {
        TrendingView()
    }
}
