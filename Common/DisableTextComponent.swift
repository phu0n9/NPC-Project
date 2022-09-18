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

struct DisableTextComponent: View {
    @Binding var title : String
    @Binding var textValue : String
    
    var body: some View {
        VStack(alignment: .center) {
            Capsule()
            /* #f5f5f5 */
                .foregroundColor(.white)
                .frame(width: 200, height: 40, alignment: .center)
                .padding(0)
                .overlay(
                    HStack {
            
                        TextField(title, text: $textValue)
                            .keyboardType(.emailAddress)
                            .disabled(true)
                            .frame(width: 200, height: 40, alignment: .center)
                    }
                )
                .padding(6)
                .autocapitalization(.none)
        }
    }
}

struct DisableTextComponent_Previews: PreviewProvider {
    static var previews: some View {
        DisableTextComponent(title: Binding.constant("username"), textValue: Binding.constant("Phuong"))
    }
}
