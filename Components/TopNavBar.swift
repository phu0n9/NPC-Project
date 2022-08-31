//
//  TopNavBar.swift
//  NPC
//
//  Created by Sang Yeob Han  on 31/08/2022.
//icons8.com/icons/set/xcode
//www.flaticon.com/search?word=chat

import SwiftUI

let text = NSMutableAttributedString.init(string: "hello")
let range = NSMakeRange(0, text.length)

struct TopNavBar: View {


    var body: some View {
        VStack(spacing:0.0){
           HStack{
            
            Text("Trending")
                .font(.headline)
                .padding(20)
            
            Spacer()
            
            HStack(spacing:20.0){
                Image("search-icon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                Image("notification-icon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                Image("chat-icon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            .padding(.horizontal,15)
            .padding(.vertical,3)
               
            Spacer()
    }
            
        }
}

struct TopNavBar_Previews: PreviewProvider {
    static var previews: some View {
        TopNavBar()
    }
}

}
