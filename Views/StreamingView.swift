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
        let currentTime = self.soundControl.audioPlayer.currentTime().seconds
        let total = (self.soundControl.audioPlayer.currentItem?.duration.seconds)!
        let progress = currentTime / total
        withAnimation(.linear(duration: 0.1)) {
            self.soundControl.angle = Double(progress) * 288

        }
    }

}

struct StreamingView_Previews: PreviewProvider {
    static var previews: some View {
        StreamingView(episode: Binding.constant(Episodes(audio: "", audio_length: 0, description: "", episode_uuid: "", podcast_uuid: "", pub_date: "", title: "", image: "", user_id: "", isLiked: false)), upload: Binding.constant(Uploads(title: "", description: "", audioPath: "", author: "", pub_date: "", image: "", userID: "", numOfLikes: 0, audio_length: 0, userImage: "", likes: [], comments: [])), download: Binding.constant(Downloads(audio: "", title: "", isProcessing: false, audio_length: 0)), state: 0)
    }
}

//    static var previews: some View {
//        StreamingView(episode: Binding.constant(Episodes(audio: "http://feedproxy.google.com/~r/wskbcast/~5/Bfv7vOn-sMI/Ep88AWatchedGoatNeverBurns.mp3", audio_length: 4638, description: "This week Kyle has us going from the adorable Gävle Goat to barber pole! Sky dives into figural biscuit-making and kids games as Tim hunts down one of the most iconic Bugs Bunny cartoons.Photos & Videos we talk about:7:00 - Hobby horse12:55 - Guy who showed up to the wrong party Subscribe in iTunesListen on Stitcher Radio", episode_uuid: "6bf59a32de804ede9101f7ba75d12677", podcast_uuid: "0c28802a7e814a55ada3ba54847258bc", pub_date: "2017-12-07 13:59:00+00", title: "Ep88: A Watched Goat Never Burns", image: "http://is5.mzstatic.com/image/thumb/Music71/v4/f8/a3/3e/f8a33e4e-bd23-ca5d-1aa2-bdb0e6b0f74b/source/600x600bb.jpg", user_id: "BbxvolHkIRdRCoGOJ1jfuE9RHoe2", isLiked: false)), upload: Binding.constant(Uploads(title: "Nguyễn Lê", description: "ss", audioPath: "https://firebasestorage.googleapis.com:443/v0/b/npc-project-742bd.appspot.com/o/recordings%2FE7B45BC1-3660-4BAC-AA7E-5FDCACF83B99?alt=media&token=49828066-fa93-424c-98f7-fc7086d5c3b8", author: "Lenguyen", pub_date: "9/16/22, 12:46 AM", image: "https://firebasestorage.googleapis.com:443/v0/b/npc-project-742bd.appspot.com/o/recording_images%2F03125B60-4A7C-4B40-AC95-719DBE4C4D42.jpg?alt=media&token=adb2f507-0fc0-4e28-9f27-fcf2267ea6df", userID: "BbxvolHkIRdRCoGOJ1jfuE9RHoe2", numOfLikes: 0, audio_length: 0, userImage: "https://firebasestorage.googleapis.com:443/v0/b/npc-project-742bd.appspot.com/o/images%2FE867F8D3-88CF-428D-BC3D-E6BCDD6D87F8.jpg?alt=media&token=aace0e1e-9e3d-4958-a4a9-733cf0a202bb", likes: [], comments: [])), state: 0)
//    }
