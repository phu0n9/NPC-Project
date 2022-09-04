//
//  PlayButton.swift
//  NPC
//
//  Created by Le Nguyen on 03/09/2022.
//

import SwiftUI

struct PlayButton: View {
    
    @State public var isActive = false
    @State public var btnClicked = 0
    
    var body: some View {
        HStack{
            VStack(spacing:10) {
                Button(action: {
                    btnClicked += 1
                    print("Hello button tapped!")
                }) {
                    if btnClicked%2 == 0{
                        Image("play-circle-icon")
                            .renderingMode(.template)
                            .foregroundColor(.orange)
                            .frame(width:15, height: 6, alignment: .leading)
                            .padding(5)
                        
                        Text("Length")
                            .font(.caption)
                            .foregroundColor(.black)
                            .padding(9)
                    } else{
                        Image("pause-circle-icon")
                            .renderingMode(.template)
                            .foregroundColor(.orange)
                            .frame(width:15, height: 6, alignment: .leading)
                            .padding(5)
                        Text("Length")
                            .font(.caption)
                            .foregroundColor(.black)
                            .padding(9)
                    }
                }
        }.overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(red: 1, green: 0.4902, blue: 0.3216), lineWidth: 1))
        
            Image("mylist-icon")
                .resizable()
                .frame(width:20, height: 20, alignment: .leading)
                .padding()
            Image("download-icon")
                .resizable()
                .frame(width:20, height: 15, alignment: .leading)
        }.padding()
    }
    

}

struct PlayButton_Previews: PreviewProvider {
    static var previews: some View {
        PlayButton()
    }
}