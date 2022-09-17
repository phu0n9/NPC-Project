//
//  SoundControl.swift
//  NPC
//
//  Created by Nguyen Huynh Phuong Anh on 05/09/2022.
//

import Foundation
import AVFoundation
import AVKit
import SwiftUI


class SoundControl: NSObject, ObservableObject, AVAudioPlayerDelegate {
    
    @Published var audioPlayer: AVPlayer!

    @Published var isActive: Bool = true
    @Published var angle : Double = 0
    @Published var episode = Episodes(audio: "", audio_length: 0, description: "", episode_uuid: "", podcast_uuid: "", pub_date: "", title: "", image: "", user_id: "", isLiked: false)


    
    // MARK: only play preview of 10 seconds
    func playSound(soundName: String, isPreview: Bool) {
        self.isActive.toggle()
        let url = URL.init(string: soundName)
        guard url != nil else {
            return
        }
        self.audioPlayer = AVPlayer(playerItem: AVPlayerItem(url: url!))
        
        if self.isActive {
            self.audioPlayer.pause()
        } else {
            self.audioPlayer.play()
            
            if isPreview {
                DispatchQueue.main.asyncAfter(deadline: .now() + 7.0) {
                    self.audioPlayer.volume = 2.0
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 9.0) {
                    self.audioPlayer.volume = 1.0
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
                    self.audioPlayer.pause()
                    self.isActive.toggle()
                }
                
            }
        }
    }
    
    
    
    func onChanged(value: DragGesture.Value) {
        
        let vector = CGVector(dx: value.location.x, dy: value.location.y)
        
        let radians = atan2(vector.dy - 12.5, vector.dx - 12.5)
        let tempAngle = radians * 180 / .pi
        
        let angle = tempAngle < 0 ? 360 + tempAngle : tempAngle
        
        if angle <= 288 {
            let progress = angle / 288
            let time = TimeInterval(progress) * Double(episode.audio_length)
//            audioPlayer.currentItem?.currentTime() = time
//            audioPlayer.play()
            withAnimation(Animation.linear(duration: 0.1)) {
                self.angle =  Double(angle)
            }
        }
    }
}
