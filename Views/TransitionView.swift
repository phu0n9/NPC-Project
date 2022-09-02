//
//  TransitionView.swift
//  NPC
//
//  Created by Nguyen Anh Minh on 02/09/2022.
//

import SwiftUI

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
