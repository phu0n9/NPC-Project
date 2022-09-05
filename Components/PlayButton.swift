//
//  PlayButton.swift
//  NPC
//
//  Created by Le Nguyen on 03/09/2022.
//

import SwiftUI

struct PlayButton: View {
    
    @State private var isDownload = 0
    @State private var isAddedToMyList = 0
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
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(.orange)
                            .frame(width:30, height: 30, alignment: .leading)
                            .padding(5)
                        
                        Text("Length")
                            .font(.caption)
                            .foregroundColor(.black)
                            .padding(9)
                    } else{
                        Image("pause-icon")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(.orange)
                            .frame(width:30, height: 30, alignment: .leading)
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
        
            Button(action: {
                isAddedToMyList += 1
                print("addlist-button cliekd")
            }) {
                if isAddedToMyList%2 == 0{
                    Image("add-list-icon")
                        .frame(width:20, height: 20, alignment: .leading)
                        .padding()
                }else{
                    Image("add-list-icon")
                        .renderingMode(.template)
                        .foregroundColor(.orange)
                        .frame(width:20, height: 20, alignment: .leading)
                        .padding()
                }
            }
            
            Button(action: {
                isDownload += 1
                print("download-button cliekd")
            }) {
                if isDownload%2 == 0{
                    Image("download-icon")
                        .frame(width:15, height: 15, alignment: .leading)
                        .padding()

                }else{
                    Image("download-icon")
                        .renderingMode(.template)
                        .foregroundColor(.orange)
                        .frame(width:15, height: 10, alignment: .leading)
                        .padding()
                }
            }

        }.padding()
    }
    

}

struct PlayButton_Previews: PreviewProvider {
    static var previews: some View {
        PlayButton()
    }
}
