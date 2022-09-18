//
//  TimerForCastingView.swift
//  NPC
//
//  Created by Sang Yeob Han  on 15/09/2022.
//

import Foundation
class TimerForCasting : ObservableObject {
    
    @Published var hours: Int8 = 00
    @Published var minutes: Int8 = 00
    @Published var seconds: Int8 = 00
    @Published var timerIsPaused: Bool = true
    @Published var timer: Timer?
    
    func restartTimer() {
        hours = 0
        minutes = 0
        seconds = 0
    }
    
    func startTimer() {
        timerIsPaused = false
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if self.seconds == 59 {
              self.seconds = 0
              if self.minutes == 59 {
                self.minutes = 0
                self.hours += 1
              } else {
                self.minutes += 1
              }
            } else {
              self.seconds += 1
            }
        }
    }
    
    func stopTimer() {
        timerIsPaused = true
        timer?.invalidate()
        timer = nil
    }
    
}
