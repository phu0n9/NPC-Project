//
//  StreamingView.swift
//  NPC
//
//  Created by Sang Yeob Han  on 11/09/2022.
//

import SwiftUI
import AVKit

struct StreamingView: View {
    
    @ObservedObject var podcastViewModel = PodcastViewModel()
    @ObservedObject var userSettings = UserSettings()
    
//   @State var width : CGFloat = UIScreen.main.bounds.height < 750 ? 130 : 230
    var width:CGFloat = 200
    var height:CGFloat = 200
    

     
    var body: some View {

        VStack{
           Spacer(minLength: 0)
            
            ZStack{
                Image(systemName: "leaf.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: width, height: height)
                    .clipShape(Circle())
                
                ZStack{
                    Circle()
                        .trim(from: 0, to:0.8)
                        .stroke(Color.black.opacity(0.06),lineWidth: 4)
                        .frame(width: width+45, height: height+45)
                    
                    Circle()
                        .trim(from: 0, to: CGFloat((podcastViewModel.angle)/360))
                        .stroke(Color("blue"),lineWidth: 4)
                        .frame(width: width+45, height: height+45)
                    
                    Circle()
                        .fill(Color("blue"))
                        .frame(width: 25, height: 25)
                        .offset(x: (width + 45) / 2)
                        .rotationEffect(.init(degrees: podcastViewModel.angle))
                        .gesture(DragGesture().onChanged(podcastViewModel.onChanged(value:)))
                }
                .rotationEffect(.init(degrees: 126))
            }

            Text("title")
                .font(.title2)
                .fontWeight(.heavy)
                .foregroundColor(.black)
                .padding(.top,25)
                .padding(.horizontal)
                .lineLimit(1)
            
            Text("author")
                .foregroundColor(.gray)
                .padding(.top,5)
            
            Spacer()
        }
    
    }
        
}

struct StreamingView_Previews: PreviewProvider {
    static var previews: some View {
        StreamingView()
    }
}

