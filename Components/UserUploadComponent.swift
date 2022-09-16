//
//  UserUploadComponent.swift
//  NPC
//
//  Created by Sang Yeob Han  on 16/09/2022.
//

import SwiftUI

struct UserUploadComponent: View {
    var body: some View {
        
        VStack{

                HStack{
                    Image(systemName: "leaf.fill")
                        .resizable()
                        .font(.title)
                        .frame(width: 50, height: 50)
                        .clipShape(Rectangle())
                        .foregroundColor(.orange)
                        .cornerRadius(10)
                        .padding(5)
            
        
                    VStack{
                        // MARK: title
                        Text("title")
                            .font(.system(size: 14))
                            .lineLimit(1)

                    // MARK: publish date
                    Text("uplodade date")
                        .font(.system(size: 10))
                        .foregroundColor(.gray)
                    }.padding()
                    Spacer()
                    
                }.padding(10)
            
               HStack{
                   UserUploadButton()
               }.padding(0)
        }.padding()
        

    }
}

struct UserUploadComponent_Previews: PreviewProvider {
    static var previews: some View {
        UserUploadComponent()
    }
}
