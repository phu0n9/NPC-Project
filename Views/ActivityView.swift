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

// MARK: activity tab bar
struct ActivityView: View {
    @State var currentTab: Int = 0
    let tabOptions = [0: Settings.favoriteListCollection, 1: Settings.download, 2: Settings.watchListCollection]
    let titleTab = [0: "Favorite List", 1: "Download List", 2: "History List"]

    var body: some View {
        VStack {
            TabBarView(currentTab: self.$currentTab, state: 0)
            TabView(selection: self.$currentTab) {
                ActivityViewItem(selectedTab: currentTab, currentTabCollection: Binding.constant(tabOptions[currentTab] ?? Settings.favoriteListCollection), currentTabTitle: Binding.constant(titleTab[currentTab] ?? "Favorite List")).tag(0)
                DownloadView().tag(1)
                ActivityViewItem(selectedTab: currentTab, currentTabCollection: Binding.constant(tabOptions[currentTab] ?? Settings.favoriteListCollection), currentTabTitle: Binding.constant(titleTab[currentTab] ?? "Favorite List")).tag(2)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
    }
}

struct ActivityView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityView()
    }
}
