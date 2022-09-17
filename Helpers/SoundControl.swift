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

import SwiftUI

class SoundControl: NSObject, ObservableObject, AVAudioPlayerDelegate {
    
    @Published var audioPlayer: AVPlayer?
    
    @Published var isActive: Bool = true
    @Published var episode = Episodes(audio: "", audio_length: 0, description: "", episode_uuid: "", podcast_uuid: "", pub_date: "", title: "", image: "", user_id: "", isLiked: false)
    
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
}
