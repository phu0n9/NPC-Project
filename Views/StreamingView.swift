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
    @StateObject var userViewModel = UserViewModel()
    @ObservedObject var uploadViewModel = UploadViewModel()
    @ObservedObject var userSettings = UserSettings()
    @Binding var episode: Episodes
    @ObservedObject var soundControl = SoundControl()
    @Binding var upload: Uploads
    
    //   @State var width : CGFloat = UIScreen.main.bounds.height < 750 ? 130 : 230
    var width : CGFloat = 200
    var height : CGFloat = 200
    var state: Int
    //    var isplaying:Bool = false;
    //
    var body: some View {
        VStack {
            Spacer(minLength: 0)
            
            ZStack {
                // MARK: podcast image
                AsyncImage(url: URL(string: self.state == 0 ? self.episode.image : self.upload.image)) { image in
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
                        .stroke(Color.black.opacity(0.06), lineWidth: 4)
                        .frame(width: width+45, height: height+45)
                    // MARK: add tenery operator based on state below theses circles
                    Circle()
                        .trim(from: 0, to: CGFloat((podcastViewModel.angle)/360))
                        .stroke(Color(.orange), lineWidth: 4)
                        .frame(width: width+45, height: height+45)
                    
                    
                    Circle()
                        .fill(Color("MainButton"))
                        .frame(width: 25, height: 25)
                        .offset(x: (width + 45) / 2)
                        .rotationEffect(.init(degrees: podcastViewModel.angle))
                        .gesture(DragGesture().onChanged(podcastViewModel.onChanged(value:)))
                }
                .rotationEffect(.init(degrees: 126))
            }.padding(30)
            
            // MARK: PLAY BTN
            HStack(spacing:50) {
                
                Button(action: {
                    soundControl.playSound(soundName: self.state == 0 ? self.episode.audio : self.upload.audioPath, isPreview: false)
                }, label: {
                    Image(systemName: self.soundControl.isActive ?  "play.fill" : "pause.fill")
                        .resizable()
                        .font(.title)
                        .foregroundColor(.orange)
                        .frame(width: 50, height: 50, alignment: .center)
                })
            }
            Spacer()
            
            HStack {
                
                Image(systemName: "person")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 45, height: 45)
                    .clipShape(Circle())
                
                VStack {
                    Text(self.state == 0 ? self.episode.title : self.upload.title)
                        .font(.caption)
                        .fontWeight(.heavy)
                        .foregroundColor(.black)
                        .lineLimit(1)
                        .frame(alignment: .trailing)
                    
                    Text(self.state == 0 ? self.podcastViewModel.podcast.author : self.upload.author)
                        .font(.caption2)
                        .foregroundColor(.gray)
                        .lineLimit(1)
                    
                }.padding()
                
                Spacer()
                
                HStack {
                    Spacer()
                    VStack {
                        if state == 1 {
                            Image(systemName: "message")
                                .resizable()
                                .frame(width: 20, height: 20)
                            
                            Text("comments(INT)")
                                .font(.caption2)
                                .foregroundColor(.gray)
                                .lineLimit(1)
                        }
                        Image(systemName: "heart")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .onTapGesture {
                                if state == 0 {
                                    DispatchQueue.main.async {
                                        self.userViewModel.addFavorite(favorite: episode)
                                    }
                                } else {
                                    print("Users like this upload")
                                }
                            }
                        if state == 1 {
                            Text("likes(INT)")
                                .font(.caption2)
                                .foregroundColor(.gray)
                                .lineLimit(1)
                        }
                    }
                }.padding()
                
            }.padding()
        }
        .onAppear {
            DispatchQueue.main.async {
                if state == 0 {
                    self.podcastViewModel.fetchPodcastById(podcastId: self.episode.podcast_uuid, episodeId: self.episode.episode_uuid)
                    self.userViewModel.addWatchList(watchItem: self.episode)
                } else {
                    print("fetching uploads")
                }
            }
        }
    }
}

struct StreamingView_Previews: PreviewProvider {
    static var previews: some View {
        StreamingView(episode: Binding.constant(Episodes(audio: "", audio_length: 0, description: "", episode_uuid: "", podcast_uuid: "", pub_date: "", title: "", image: "", user_id: "", isLiked: false)), upload: Binding.constant(Uploads(title: "", description: "", audioPath: "", author: "", pub_date: "", image: "", userID: "", numOfLikes: 0, audio_length: 0, likes: [], comments: [])), state: 0)
    }
}
