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
    var body: some View {
        NavigationView {
            VStack {
                destination
            }
            .navigationTitle(self.viewTitle)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        print("search clicked")
                    } label: {
                        Image("search-icon")
                            .resizable()
                            .frame(width: 30, height: 30, alignment: .leading)
                    }
                     
                    Button {
                        print("notification clicked")
                    } label: {
                        Image("notification-icon")
                            .resizable()
                            .frame(width: 30, height: 30, alignment: .leading)
                    }
                    
                    Button {
                        print("message clicked")
                    } label: {
                        Image("chat-icon")
                            .resizable()
                            .frame(width: 20, height: 20, alignment: .leading)
                    }
                }
            }
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
