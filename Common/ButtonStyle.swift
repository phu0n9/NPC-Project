//
//  ButtonStyle.swift
//  NPC
//
//  Created by Le Nguyen on 06/09/2022.
//

import SwiftUI

struct CustomeButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color(red: 0, green: 0, blue: 0.5))
            .foregroundColor(.white)
            .clipShape(Capsule())
    }
}
