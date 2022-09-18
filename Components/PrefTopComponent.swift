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

struct PrefTopComponent: View {
    var body: some View {
        VStack(spacing: 16) {
            Button {
            } label: {
                Image("transition")
                    .font(.system(size: 64))
                    .padding()
            }
            Text("Create Your Account")
                .multilineTextAlignment(.center)
                .padding(.vertical, 5)
                .font(.system(size: 26, weight: .semibold))
            Text("Tell us about your preference topic")
                .multilineTextAlignment(.center)
                .padding(.vertical, 5)
                .font(.system(size: 16, weight: .semibold))
            Text("Podcast recommendation on the Trending page will be based on your selection in here. You may edit the preference later in the profile.")
                .foregroundColor(.gray)
                .font(.system(size:14))
                .padding(5)
        }
    }
}

struct PrefTopComponent_Previews: PreviewProvider {
    static var previews: some View {
        PrefTopComponent()
    }
}
