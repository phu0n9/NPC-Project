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

struct TabBarView: View {
    @Binding var currentTab: Int
    @Namespace var namespace
    
    var myListTabBarOptions: [String] = ["My List", "Download", "History"]
    var castingTabBarOptions: [String] = ["Community", "Your cast"]
    var state : Int
    
    var body: some View {
        VStack(alignment: .center) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .center, spacing: 40) {
                    ForEach(Array(zip(self.state == 0 ? self.myListTabBarOptions.indices : self.castingTabBarOptions.indices,
                                      self.state == 0 ? self.myListTabBarOptions : self.castingTabBarOptions)),
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
            TabBarView(currentTab: Binding.constant(0), state: 0)
        }
    }
}
