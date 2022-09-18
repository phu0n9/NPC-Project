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

// MARK: transition view while waiting
struct TransitionView: View {
    @State private var currentColorIndex = 0
    @State private var scaleRate = 0.1
        
    private let colors: [Color] = [
        .orange, .green, .cyan, .mint, .blue
    ]
        
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
        
    private var repeatingAnimation: Animation {
        Animation
            .easeInOut(duration: 1)
            .repeatForever()
    }
    
    var body: some View {
        VStack {
            Image("transition")
                .resizable()
                .frame(width: 121, height: 171, alignment: .center)
                .padding()
            HStack {
                Text("Processing ").font(Font.system(size:30, design: .serif))
                .multilineTextAlignment(.center)
                .padding()
                Circle()
                    .foregroundColor(colors[currentColorIndex])
                    .frame(width: 5, height: 5)
                    .scaleEffect(scaleRate)
                    .onAppear {
                        withAnimation(self.repeatingAnimation) {
                            self.scaleRate = 3
                            }
                        }
                        .onReceive(timer) { _ in
                            self.currentColorIndex = (self.currentColorIndex + 1) >= self.colors.count ? 0: self.currentColorIndex + 1
                        }
                        .padding()
                Circle()
                    .foregroundColor(colors[currentColorIndex])
                    .frame(width: 5, height: 5)
                    .scaleEffect(scaleRate)
                    .onAppear {
                        withAnimation(self.repeatingAnimation) {
                            self.scaleRate = 3
                            }
                        }
                        .onReceive(timer) { _ in
                            self.currentColorIndex = (self.currentColorIndex + 1) >= self.colors.count ? 0: self.currentColorIndex + 1
                        }
                        .padding()
                Circle()
                    .foregroundColor(colors[currentColorIndex])
                    .frame(width: 5, height: 5)
                    .scaleEffect(scaleRate)
                    .onAppear {
                        withAnimation(self.repeatingAnimation) {
                            self.scaleRate = 3
                            }
                        }
                        .onReceive(timer) { _ in
                            self.currentColorIndex = (self.currentColorIndex + 1) >= self.colors.count ? 0: self.currentColorIndex + 1
                        }
                        .padding()
            }
        }
    }
}

struct TransitionView_Previews: PreviewProvider {
    static var previews: some View {
        TransitionView()
    }
}
