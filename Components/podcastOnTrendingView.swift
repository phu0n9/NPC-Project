//
//  podcastOnTrendingView.swift
//  NPC
//
//  Created by Le Nguyen on 03/09/2022.
//

import SwiftUI

struct podcastOnTrendingView: View {
    var body: some View {
        VStack{
        Rectangle()
            .font(.title)
            .frame(width: 90, height: 90,alignment: .leading)
            .foregroundColor(.orange)
            .cornerRadius(20)
            HStack(alignment: .firstTextBaseline, spacing: 10){
                Text("Title 1")
                    .font(.title3)
                    .frame(alignment: .leading)
                Image("add-list-icon")
                    .resizable()
                    .frame(width: 20, height: 20, alignment: .leading)
            }.padding(0)
            Text("BroadCasting station")
                .font(.caption)
                .foregroundColor(.gray)
                .frame(alignment: .leading)
        }.padding(0)
    }
}

struct podcastOnTrendingView_Previews: PreviewProvider {
    static var previews: some View {
        podcastOnTrendingView()
    }
}
