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

import Foundation
import AVFoundation
import AVKit
import SwiftUI

class SoundControl: NSObject, ObservableObject, AVAudioPlayerDelegate {
    
    @Published var audioPlayer: AVPlayer?
    
    @Published var isActive: Bool = true
    @Published var episode = Episodes(audio: "", audio_length: 0, description: "", episode_uuid: "", podcast_uuid: "", pub_date: "", title: "", image: "", user_id: "", isLiked: false)
    @Published var angle : Double = 0

    // MARK: play sound local and url
    func playSound(soundName: String, isLocalFile: Bool) {
        self.isActive.toggle()
        let url = isLocalFile ? URL(fileURLWithPath: soundName) : URL.init(string: soundName)
        guard url != nil else {
            return
        }
        self.audioPlayer = AVPlayer(playerItem: AVPlayerItem(url: url!))
        
        if let player = self.audioPlayer {
            if self.isActive {
                player.pause()
            } else {
                player.play()
            }
        }
    }
    
    // MARK: get current time
    func getCurrentTime(value: TimeInterval) -> String {
        return "\(Int(value / 60)):\(Int(value.truncatingRemainder(dividingBy: 60)) < 9 ? "0" : "")\(Int(value.truncatingRemainder(dividingBy: 60)))"
    }
    
    func updateTimer() {
        if let player = self.audioPlayer {
            let currentTime = player.currentTime().seconds
            let total = player.currentItem?.duration.seconds
            if let totalTime = total, !totalTime.isNaN {
                let progress = currentTime / totalTime
                withAnimation(.linear(duration: 0.1)) {
                    self.angle = Double(progress) * 288
                }
            }
        }
    }
    
    // MARK: on drag gesture changes
    func onChanged(value: DragGesture.Value) {
        let vector = CGVector(dx: value.location.x, dy: value.location.y)
        let radians = atan2(vector.dy - 12.5, vector.dx - 12.5)
        let tempAngle = radians * 180 / .pi
        let angle = tempAngle < 0 ? 360 + tempAngle : tempAngle
        if angle <= 288 {
            let progress = angle / 288
            if let player = self.audioPlayer {
                player.pause()
                let time = TimeInterval(progress) * Double(Float((player.currentItem?.duration.seconds)!))
                player.seek(to: CMTime(seconds: time, preferredTimescale: 1))
                player.play()
            }
        }
    }
}
