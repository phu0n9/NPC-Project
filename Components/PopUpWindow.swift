//
//  PopUpWindow.swift
//  NPC
//
//  Created by Sang Yeob Han  on 15/09/2022.
//

import SwiftUI

struct PopUpWindow: View {
    var title: String
    var message: String
    var buttonText: String
    @Binding var show: Bool
    var body: some View {
        ZStack {
            if show {
                // PopUp background color
                // Color.black.opacity(show ? 0.3 : 0).edgesIgnoringSafeArea(.all)
                // PopUp Window
                VStack(alignment: .center, spacing: 0) {
                    Text(title)
                        .frame(maxWidth: .infinity)
                        .frame(height: 45, alignment: .center)
                        .font(Font.system(size: 23, weight: .semibold))
                        .foregroundColor(Color.white)
                        .background(Color.orange)
                    Text(message)
                        .multilineTextAlignment(.center)
                        .font(Font.system(size: 16, weight: .semibold))
                        .padding(EdgeInsets(top: 20, leading: 25, bottom: 20, trailing: 25))
                        .foregroundColor(Color.white)
                    Button(action: {
                        // Dismiss the PopUp
                        withAnimation(.linear(duration: 0.3)) {
                            show = false
                        }
                    }, label: {
                        Text(buttonText)
                            .frame(maxWidth: .infinity)
                            .frame(height: 54, alignment: .center)
                            .foregroundColor(Color.white)
                            .background(Color.orange)
                            .font(Font.system(size: 23, weight: .semibold))
                    }).buttonStyle(PlainButtonStyle())
                }
                .frame(maxWidth: 300)
                .border(Color.white, width: 2)
                .background(Color.orange)
            }
        }
    }
}
