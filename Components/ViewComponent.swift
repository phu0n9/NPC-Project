//
//  ViewComponent.swift
//  NPC
//
//  Created by Nguyen Huynh Phuong Anh on 05/09/2022.
//

import SwiftUI

struct ViewComponent<Destination:View>: View {
    var destination: Destination
    var viewTitle: String
    
   var navStyle = UIImageView(image: UIImage(named: "logo"))
    
    var body: some View {
    
        NavigationView {
            HStack {
                destination
                    
            }
            .navigationTitle(self.viewTitle)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        print("search clicked")
                    } label: {
                        Image(systemName: "waveform.and.magnifyingglass")
                            .resizable()
                            .frame(width: 20, height: 20, alignment: .leading)
                    }
                     
                    Button {
                        print("notification clicked")
                    } label: {
                        Image(systemName: "bell")
                            .resizable()
                            .frame(width: 20, height: 20, alignment: .leading)
                    }
                }
            }
            .accessibilityIdentifier(/*@START_MENU_TOKEN@*/"Identifier"/*@END_MENU_TOKEN@*/)
            
            
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarHidden(true)
    }
}

struct ViewComponent_Previews: PreviewProvider {
    static var previews: some View {
        ViewComponent(destination: TrendingView(), viewTitle: "Trending")
    }
}
