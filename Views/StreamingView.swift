//
//  StreamingView.swift
//  NPC
//
//  Created by Sang Yeob Han  on 11/09/2022.
//

import SwiftUI
import AVKit
import PopupView

struct StreamingView: View {
    
    @ObservedObject var podcastViewModel = PodcastViewModel()
    @ObservedObject var soundControlModel = SoundControl()
    @StateObject var userViewModel = UserViewModel()
    @ObservedObject var userSettings = UserSettings()
    @ObservedObject var soundControl = SoundControl()
    @StateObject var uploadViewModel = UploadViewModel()
    @Binding var episode: Episodes
    @Binding var upload: Uploads
    @Binding var download: Downloads
    @State var isCommentTapped: Bool = false
    @State var timer = Timer.publish(every: 1, on: .current, in: .default).autoconnect()
    
    var width : CGFloat = 200
    var height : CGFloat = 200
    // MARK: 0 is episode view, 1 is casting view, 2 is download view
    var state: Int
    
    var body: some View {
        VStack {
            
            Capsule()
                .fill(Color.secondary)
                .frame(width: 50, height: 3)
                .padding(10)
            
            Spacer(minLength: 0)
            
            ZStack {
                if state != 2 {
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
                } else {
                    Image(systemName: "music.note")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: width, height: height)
                        .clipShape(Circle())
                }
                
                ZStack {
                    Circle()
                        .trim(from: 0, to:0.8)
                        .stroke(Color.black.opacity(0.06), lineWidth: 4)
                        .frame(width: width+45, height: height+45)

                    Circle()
                        .trim(from: 0, to: CGFloat((self.soundControl.angle)/360))
                        .stroke(Color(.orange), lineWidth: 4)
                        .frame(width: width+45, height: height+45)
                    
                    Circle()
                        .fill(Color("MainButton"))
                        .frame(width: 25, height: 25)
                        .offset(x: (width + 45) / 2)
                        .rotationEffect(.init(degrees: soundControlModel.angle))
                        .gesture(DragGesture().onChanged(soundControlModel.onChanged(value:)))

                }
                .rotationEffect(.init(degrees: 126))
            
            }.padding(30)
            
            // MARK: PLAY BTN
            HStack(spacing:50) {
                
                Button(action: {
                    if state != 2 {
                        soundControl.playSound(soundName: self.state == 0 ? self.episode.audio : self.upload.audioPath, isLocalFile: false)
                    } else {
                        soundControl.playSound(soundName: self.download.audio, isLocalFile: true)
                    }
                }, label: {
                    Image(systemName: self.soundControl.isActive ?  "play.fill" : "pause.fill")
                        .resizable()
                        .font(.title)
                        .foregroundColor(Color("MainButton"))
                        .frame(width: 50, height: 50, alignment: .center)
                })
            }
            
            Spacer()
            
            HStack {
                if state == 1 && self.upload.userImage == "" {
                    Image(systemName: "person")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 45, height: 45)
                        .clipShape(Circle())
                } else if state == 2 {
                    Image(systemName: "music.note")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 45, height: 45)
                        .clipShape(Circle())
                } else {
                    AsyncImage(url: URL(string: self.state == 0 ? self.episode.image : self.upload.userImage)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 45, height: 45)
                            .clipShape(Circle())
                    } placeholder: {
                        ProgressView()
                    }
                }
                
                VStack {
                    if state != 2 {
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
                    } else {
                        Text(self.download.title)
                            .font(.caption)
                            .fontWeight(.heavy)
                            .foregroundColor(.black)
                            .lineLimit(1)
                            .frame(alignment: .trailing)
                    }
                    
                }
                .padding()
                
                Spacer()
                
                HStack {
                    Spacer()
                    VStack {
                        if state == 1 {
                            Image(systemName: "message")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .onTapGesture {
                                    self.isCommentTapped = true
                                }
                            
                            Text("\(self.uploadViewModel.commentList.count) comments")
                                .font(.caption2)
                                .foregroundColor(.gray)
                                .lineLimit(1)
                        }

                        if state == 1 {
                            Text("\(self.upload.numOfLikes) likes")
                                .font(.caption2)
                                .foregroundColor(.gray)
                                .lineLimit(1)
                        }
                    }
                }
                .padding()
            }.padding()
        }
        .background(Color(UIColor.systemBackground))
        .onAppear {
            DispatchQueue.main.async {
                if state == 0 {
                    self.podcastViewModel.fetchPodcastById(podcastId: self.episode.podcast_uuid, episodeId: self.episode.episode_uuid)
//                    self.userViewModel.addWatchList(watchItem: self.episode)
                    soundControl.playSound(soundName: self.state == 0 ? self.episode.audio : self.upload.audioPath, isLocalFile: false)
                    self.soundControl.audio_length = self.episode.audio_length
                } else if state == 1 {
                    self.uploadViewModel.fetchCommentsByUploadID(uploadID: self.upload.uuid)
                    soundControl.playSound(soundName: self.state == 0 ? self.episode.audio : self.upload.audioPath, isLocalFile: false)
                    self.soundControl.audio_length = self.upload.audio_length
                } else {
                    soundControl.playSound(soundName: self.download.audio, isLocalFile: true)
                    self.soundControl.audio_length = Int(self.download.audio_length)
                }
            }
        }
        .sheet(isPresented: self.$isCommentTapped) {
            CommentView(upload: self.upload)
        }
        .onReceive(timer) { _ in
            self.updateTimer()
        }
    }
    
    func updateTimer() {
//        let currentTime = self.soundControl.audioPlayer.currentTime().seconds
//        let total = (self.soundControl.audioPlayer.currentItem?.duration.seconds)!
//        let progress = currentTime / total
//        withAnimation(.linear(duration: 0.1)) {
//            self.soundControl.angle = Double(progress) * 288
//
//        }
//    }

}
}
struct StreamingView_Previews: PreviewProvider {
    static var previews: some View {
        StreamingView(episode: Binding.constant(Episodes(audio: "", audio_length: 0, description: "", episode_uuid: "", podcast_uuid: "", pub_date: "", title: "", image: "", user_id: "", isLiked: false)), upload: Binding.constant(Uploads(title: "", description: "", audioPath: "", author: "", pub_date: "", image: "", userID: "", numOfLikes: 0, audio_length: 0, userImage: "", likes: [], comments: [])), download: Binding.constant(Downloads(audio: "", title: "", isProcessing: false, audio_length: 0)), state: 0)
    }
}

