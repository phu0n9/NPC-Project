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

struct PodcastComponent: View {
    var podcast: Podcasts
    @State private var isTapped : Bool = false
    var body: some View {
        VStack {
            NavigationLink("", destination: PodcastDetailView(podcast: podcast), isActive: self.$isTapped)
            AsyncImage(url: URL(string: self.podcast.image)) { podcastImage in
                podcastImage
                    .resizable()
                    .font(.title)
                    .frame(width: 90, height: 90, alignment: .leading)
                    .foregroundColor(.orange)
                    .cornerRadius(20)
            } placeholder: {
                ProgressView()
            }
            HStack(alignment: .firstTextBaseline, spacing: 10) {
                Text(self.podcast.title)
                    .font(.caption)
                    .frame(maxWidth: 100, alignment: .leading)
            }.padding(0)
            Text(self.podcast.author)
                .font(.caption2)
                .foregroundColor(.gray)
                .frame(maxWidth: 100, alignment: .leading)
        }
        .onTapGesture {
            self.isTapped.toggle()
        }
        .padding(0)
    }
}

struct PodcastComponent_Previews: PreviewProvider {
    static var previews: some View {
        PodcastComponent(podcast: Podcasts(uuid: "", author: "", description: "", image: "", itunes_id: 23, language: "", title: "", website: "", categories: ["Technology", "Arts"], episodes: []))
    }
}
