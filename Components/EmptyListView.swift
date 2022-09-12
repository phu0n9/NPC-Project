//
//  EmptyListView.swift
//  NPC
//
//  Created by Nguyen Huynh Phuong Anh on 12/09/2022.
//

import SwiftUI

struct EmptyListView: View {
    var title: String
    var body: some View {
        VStack {
            Image("transition")
                .padding(5.0)
            Text("\(self.title) is empty.")
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(5.0)
        }
    }
}

struct EmptyListView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyListView(title: "Favorite List")
    }
}
