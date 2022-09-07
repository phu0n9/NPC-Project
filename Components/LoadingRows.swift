//
//  LoadingRows.swift
//  NPC
//
//  Created by Nguyen Huynh Phuong Anh on 08/09/2022.
//

import SwiftUI

struct LoadingRows: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top, spacing: 20) {
                // MARK: podcast image
                AsyncImage(url: URL(string: "")) { podcastImage in
                    podcastImage
                        .resizable()
                        .font(.title)
                        .frame(width: 56, height: 56)
                        .clipShape(Circle())
                        .foregroundColor(.orange)
                        .cornerRadius(20)
                        .padding(0)
                } placeholder: {
                    ProgressView()
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        // MARK: title
                        Rectangle()
                            .fill(Color.black.opacity(0.09))
                            .frame(width: 250, height: 15)
                    }
                    // MARK: publish date
                    Rectangle()
                        .fill(Color.black.opacity(0.09))
                        .frame(width: 100, height: 15)
                }
            }.padding()
            
            // MARK: description
            VStack(alignment: .leading, spacing: 12) {
                Rectangle()
                    .fill(Color.black.opacity(0.09))
                    .frame(width: 310, height: 15)
                Rectangle()
                    .fill(Color.black.opacity(0.09))
                    .frame(width: 310, height: 15)
                Rectangle()
                    .fill(Color.black.opacity(0.09))
                    .frame(width: 310, height: 15)
            }
        }
    }
}

struct LoadingRows_Previews: PreviewProvider {
    static var previews: some View {
        LoadingRows()
    }
}
