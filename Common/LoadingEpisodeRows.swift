/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2022B
  Assessment: Assignment 3
  Authors:
    Nguyen Huynh Anh Phuong - s3695662
    Le Nguyen - s3777242
    Han Sangyeob - s3821179
    Nguyen Anh Minh - s3911237
  Created  date: 29/08/2022
  Last modified: 18/09/2022
  Acknowledgments: StackOverflow, Youtube, and Mr. Tom Huynh’s slides
*/

import SwiftUI

struct LoadingEpisodeRows: View {
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
        LoadingEpisodeRows()
    }
}
