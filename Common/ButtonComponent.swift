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

struct ButtonComponent: View {
    var body: some View {
        VStack {
            Capsule()
                /* #ff7d52 */
                .foregroundColor(Color(red: 1, green: 0.4902, blue: 0.3216))
                .frame(width: 380, height: 50)
                .padding(0)
                .overlay(Text("Button Overlay Text"))
        }
    }
}

struct ButtonComponent_Previews: PreviewProvider {
    static var previews: some View {
        ButtonComponent()
    }
}
