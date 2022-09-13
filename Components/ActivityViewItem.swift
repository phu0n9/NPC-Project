//
//  ActivityViewItem.swift
//  NPC
//
//  Created by Nguyen Huynh Phuong Anh on 12/09/2022.
//

import SwiftUI

struct ActivityViewItem: View {
    @StateObject var userViewModel = UserViewModel()
    @State var selectedTab : Int
    @State private var time = Timer.publish(every: 0.1, on: .main, in: .tracking).autoconnect()
    @Binding var currentTabCollection: String
    @Binding var currentTabTitle: String
    
    var body: some View {
        ScrollView {
            VStack {
                if self.userViewModel.userActivityList.isEmpty {
                    EmptyListView(title: self.currentTabTitle)
                } else {
                    ForEach(self.$userViewModel.userActivityList, id: \.id) { $item in
                        ZStack {
                            // reaching end of the list then load new data
                            if self.userViewModel.userActivityList.last?.id == item.id && self.userViewModel.fetchingMore {
                                GeometryReader { bounds in
                                    LoadingRows()
                                        .onAppear {
                                            self.time = Timer.publish(every: 0.1, on: .main, in: .tracking).autoconnect()
                                        }
                                        .onReceive(self.time) { (_) in
                                            if bounds.frame(in: .global).maxY < UIScreen.main.bounds.height - 80 {
                                                self.userViewModel.fetchUserActivityList(listName: self.currentTabCollection)
                                                self.time.upstream.connect().cancel()
                                            }
                                        }
                                }
                                .frame(height: 300)
                            } else {
                                // return original data
                                EpisodeComponent(episode: $item, isExpanded: $item.isExpanding)
                            }
                        }
                    }
                }
            }
        }
        .onAppear {
            DispatchQueue.main.async {
                self.userViewModel.fetchUserActivityList(listName: currentTabCollection)
            }
        }
    }
}
