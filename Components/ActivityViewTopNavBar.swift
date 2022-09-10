//
//  ActivityViewTopNavBar.swift
//  NPC
//
//  Created by Nguyen Anh Minh on 09/09/2022.
//

import SwiftUI

struct ActivityViewTopNavBar: View {
    @State var selectedTab = Tabs.FirstTab
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                VStack {
                    Text("My List")
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .padding(5.0)
                }
                .onTapGesture {
                    self.selectedTab = .FirstTab
                }
                Spacer()
                VStack {
                    Text("Download")
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .padding(5.0)
                }
                .onTapGesture {
                    self.selectedTab = .SecondTab
                }
                Spacer()
                VStack {
                    Text("History")
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .padding(5.0)
                }
                .onTapGesture {
                    self.selectedTab = .ThirdTab
                }
                Spacer()
            }
            .padding(.bottom)
            
            Spacer()
            
            if selectedTab == .FirstTab {
                MyList()
            } else if selectedTab == .SecondTab {
                Download()
            } else {
                History()
            }
        }
        
    }
}

enum Tabs {
    case FirstTab
    case SecondTab
    case ThirdTab
}

struct ActivityViewTopNavBar_Previews: PreviewProvider {
    static var previews: some View {
        ActivityViewTopNavBar()
    }
}

