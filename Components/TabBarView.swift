//
//  TabBarView.swift
//  NPC
//
//  Created by Nguyen Huynh Phuong Anh on 12/09/2022.
//

import SwiftUI

struct TabBarView: View {
    @Binding var currentTab: Int
    @Namespace var namespace
    
    var tabBarOptions: [String] = ["My List", "Download", "History"]
    var body: some View {
        VStack(alignment: .center) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .center, spacing: 40) {
                    ForEach(Array(zip(self.tabBarOptions.indices,
                                      self.tabBarOptions)),
                            id: \.0,
                            content: { index, name in
                        TabBarItem(currentTab: self.$currentTab,
                                   namespace: namespace.self,
                                   tabBarItemName: name,
                                   tab: index)
                    })
                }
                .frame(width: UIScreen.main.bounds.width)
            }
            .frame(width: UIScreen.main.bounds.width, height: 50)
        }
    }
    
    struct TabBarView_Previews: PreviewProvider {
        static var previews: some View {
            TabBarView(currentTab: Binding.constant(0))
        }
    }
}
