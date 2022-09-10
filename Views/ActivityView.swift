//
//  ActivityView.swift
//  NPC
//
//  Created by Nguyen Anh Minh on 02/09/2022.
//

import SwiftUI

struct ActivityView: View {
    @ObservedObject var podcaCstViewModel = PodcastViewModel()
    @ObservedObject var userSettings = UserSettings()
    @State var time = Timer.publish(every: 0.1, on: .main, in: .tracking).autoconnect()
    
    var body: some View {
        ZStack {
            ActivityViewTopNavBar()
            Spacer()
        }
    }
}

struct ActivityView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityView()
    }
}
