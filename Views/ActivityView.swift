//
//  ActivityView.swift
//  NPC
//
//  Created by Nguyen Anh Minh on 02/09/2022.
//

import SwiftUI

struct ActivityView: View {
    @State var currentTab: Int = 0
    let tabOptions = [0: Settings.favoriteListCollection, 1: Settings.download, 2: Settings.watchListCollection]
    let titleTab = [0: "Favorite List", 1: "Download List", 2: "History List"]

    var body: some View {
        VStack {
            TabBarView(currentTab: self.$currentTab, state: 0)
            TabView(selection: self.$currentTab) {
                ActivityViewItem(selectedTab: currentTab, currentTabCollection: Binding.constant(tabOptions[currentTab] ?? Settings.favoriteListCollection), currentTabTitle: Binding.constant(titleTab[currentTab] ?? "Favorite List")).tag(0)
                ActivityViewItem(selectedTab: currentTab, currentTabCollection: Binding.constant(tabOptions[currentTab] ?? Settings.favoriteListCollection), currentTabTitle: Binding.constant(titleTab[currentTab] ?? "Favorite List")).tag(1)
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
