//
//  CheckboxToggleStyle.swift
//  NPC
//
//  Created by Le Nguyen on 06/09/2022.
//

import SwiftUI
import Foundation

struct CheckBoxToggleStyle: ToggleStyle {

    func makeBody(configuration: Configuration) -> some View {
        Button {
            configuration.isOn.toggle()
        } label: {
            Label {
                configuration.label
            } icon: {
                Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
                    .foregroundColor(configuration.isOn ? .accentColor : .secondary)
                    .accessibility(label: Text(configuration.isOn ? "Checked" : "Unchecked"))
                    .imageScale(.large)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

extension ToggleStyle where Self == CheckBoxToggleStyle {

    static var checkbox: CheckBoxToggleStyle {
        return CheckBoxToggleStyle()
    }
}
