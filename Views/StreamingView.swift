//
//  StreamingView.swift
//  NPC
//
//  Created by Sang Yeob Han  on 11/09/2022.
//

import SwiftUI
import AVKit

struct StreamingView: View {
    
    @ObservedObject var podcastViewModel = PodcastViewModel()
    @ObservedObject var userSettings = UserSettings()
    var podcast_uuid : String
    var episode_uuid : String
    
    //   @State var width : CGFloat = UIScreen.main.bounds.height < 750 ? 130 : 230
    var width:CGFloat = 200
    var height:CGFloat = 200
    
    var body: some View {
        VStack {
            Spacer(minLength: 0)
    
            ZStack {
                // MARK: podcast image
                AsyncImage(url: URL(string: self.podcastViewModel.episode.image)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: width, height: height)
                        .clipShape(Circle())
                } placeholder: {
                    ProgressView()
                }
                
                ZStack {
                    Circle()
                        .trim(from: 0, to:0.8)
                        .stroke(Color.black.opacity(0.06),lineWidth: 4)
                        .frame(width: width+45, height: height+45)
                    
                    Circle()
                        .trim(from: 0, to: CGFloat((podcastViewModel.angle)/360))
                        .stroke(Color(.orange),lineWidth: 4)
                        .frame(width: width+45, height: height+45)
                    
                    Circle()
                        .fill(Color("MainButton"))
                        .frame(width: 25, height: 25)
                        .offset(x: (width + 45) / 2)
                        .rotationEffect(.init(degrees: podcastViewModel.angle))
                        .gesture(DragGesture().onChanged(podcastViewModel.onChanged(value:)))
                }
                .rotationEffect(.init(degrees: 126))
            }

            Spacer()
            
            HStack{
                
                Image(systemName: "person")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 45, height: 45)
                    .clipShape(Circle())
                
                VStack{
                    Text(self.podcastViewModel.episode.title)
                        .font(.caption)
                        .fontWeight(.heavy)
                        .foregroundColor(.black)
                        .lineLimit(1)
                        .frame(alignment: .trailing)
                    
                    Text("UserName")
                        .font(.caption2)
                        .foregroundColor(.gray)
                        .lineLimit(1)
                    
                    Text(self.podcastViewModel.podcast.author)
                        .font(.caption2)
                        .foregroundColor(.gray)
                        .lineLimit(1)
                    
                }.padding()
                
                Spacer()
                
                HStack{
                    Spacer()
                    VStack{
                        Image(systemName: "message")
                            .resizable()
                            .frame(width: 20, height: 20)
                        
                        Text("comments(INT)")
                            .font(.caption2)
                            .foregroundColor(.gray)
                            .lineLimit(1)
                        
                        Image(systemName: "heart")
                            .resizable()
                            .frame(width: 20, height: 20)
                        
                        Text("likes(INT)")
                            .font(.caption2)
                            .foregroundColor(.gray)
                            .lineLimit(1)
                    }
                }.padding()
                
            }.padding()
        }
        .onAppear {
            DispatchQueue.main.async {
                self.podcastViewModel.fetchPodcastById(podcastId: self.podcast_uuid, episodeId: self.episode_uuid)
            }
        }
    }
}

struct StreamingView_Previews: PreviewProvider {
    static var previews: some View {
        StreamingView(podcast_uuid: "0c28802a7e814a55ada3ba54847258bc", episode_uuid: "6bf59a32de804ede9101f7ba75d12677")
    }
}
