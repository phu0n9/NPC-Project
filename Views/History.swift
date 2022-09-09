//
//  History.swift
//  NPC
//
//  Created by Nguyen Anh Minh on 09/09/2022.
//

import SwiftUI

struct History: View {
    var body: some View {
        VStack {
            // if (!item) return empty list
            Image("transition")
                .padding(5.0)
            Text("History is Empty")
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(5.0)
        }
    }
}

struct History_Previews: PreviewProvider {
    static var previews: some View {
        History()
    }
}
