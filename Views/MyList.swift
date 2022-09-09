//
//  MyList.swift
//  NPC
//
//  Created by Nguyen Anh Minh on 09/09/2022.
//

import SwiftUI

struct MyList: View {
    var body: some View {
        VStack {
            // if (!item) return empty list
            Image("transition")
                .padding(5.0)
            Text("My List is Empty")
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(5.0)
        }
    }
}

struct MyList_Previews: PreviewProvider {
    static var previews: some View {
        MyList()
    }
}
