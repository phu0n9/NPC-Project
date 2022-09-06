//
//  SoundControl.swift
//  NPC
//
//  Created by Nguyen Huynh Phuong Anh on 05/09/2022.
//

import Foundation
import AVFoundation

class SoundControl: NSObject, ObservableObject, AVAudioPlayerDelegate {
    
    var audioPlayer: AVPlayer!
    @Published var isActive: Bool = true
    
    func playSound(soundName: String) {
        print(soundName)
        self.isActive.toggle()
        let url = URL.init(string: soundName)
        guard url != nil else {
            return
        }
        self.audioPlayer = AVPlayer(playerItem: AVPlayerItem(url: url!))
        
        if self.isActive == true {
            self.audioPlayer.pause()
        } else {
            self.audioPlayer.play()
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
