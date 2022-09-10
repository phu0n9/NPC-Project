//
//  PreferenceViewTopComponent.swift
//  NPC
//
//  Created by Le Nguyen on 10/09/2022.
//

import SwiftUI

struct PrefTopComponent: View {
    var body: some View {
        VStack(spacing: 16) {
            Button {
            } label: {
                Image("transition")
                    .font(.system(size: 64))
                    .padding()
            }
            Text("Create Your Account")
                .multilineTextAlignment(.center)
                .padding(.vertical, 10)
                .font(.system(size: 26, weight: .semibold))
            Text("Tell us about your preference topic")
                .multilineTextAlignment(.center)
                .padding(.vertical, 10)
                .font(.system(size: 16, weight: .semibold))
        }
    }
}

struct PrefTopComponent_Previews: PreviewProvider {
    static var previews: some View {
        PrefTopComponent()
    }
}
