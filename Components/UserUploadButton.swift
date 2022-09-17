//
//  UserUploadButton.swift
//  NPC
//
//  Created by Sang Yeob Han  on 16/09/2022.
//

import SwiftUI

struct UserUploadButton: View {
    var body: some View {
        
        HStack {
            ZStack {
                Button(action: {

                }, label: {
                    Image(systemName:"play.fill" )
                        .renderingMode(.template)
                        .foregroundColor(.orange)
                        .frame(width:13, height: 6, alignment: .leading)
                        .padding(5)
                    Text("length")
                        .font(.caption)
                        .foregroundColor(.black)
                        .padding(9)
                })
            }
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color(red: 1, green: 0.4902, blue: 0.3216), lineWidth: 1))
            
            // MARK: heart icon
            Button(action: {
              
            }, label: {
                Image(systemName:"heart.fill")
                    .renderingMode(.template)
                    .foregroundColor(.orange)
                    .frame(width:20, height: 30, alignment: .leading)
                    .padding(5)
            }).padding(0)
            
            Text("Heart Num")
                .font(.system(size:10))

            
            Button(action: {
                
            }, label: {
                Image(systemName:"ellipsis.bubble")
                    .renderingMode(.template)
                    .foregroundColor(.orange)
                    .frame(width:20, height: 30, alignment: .leading)
                    .padding(5)
            }).padding(0)

            Text("Comment Num")
                .font(.system(size:10))

        }.padding(5)
            

        }
        }
        
      
    


struct UserUploadButton_Previews: PreviewProvider {
    static var previews: some View {
        UserUploadButton()
    }
}
