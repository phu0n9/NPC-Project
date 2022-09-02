//
//  ButtonComponent.swift
//  NPC
//
//  Created by Nguyen Anh Minh on 02/09/2022.
//

import SwiftUI

struct ButtonComponent: View {
    var body: some View {
        VStack {
            Capsule()
                /* #ff7d52 */
                .foregroundColor(Color(red: 1, green: 0.4902, blue: 0.3216))
                .frame(width: 380, height: 50)
                .padding(0)
                .overlay(Text("Button Overlay Text"))
        }
    }
}

struct ButtonComponent_Previews: PreviewProvider {
    static var previews: some View {
        ButtonComponent()
    }
}
