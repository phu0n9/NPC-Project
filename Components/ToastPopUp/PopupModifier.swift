//
//  PopupModifier.swift
//  NPC
//
//  Created by Le Nguyen on 05/09/2022.
//

import Foundation
import SwiftUI

struct PopupModifier: ViewModifier {
    
    @ObservedObject var sheetManager: SheetManager
    
    func body(content: Content) -> some View {
        content
            .overlay(alignment: .top) {
                if case let .present(config) = sheetManager.action {
                    PopUp(config: config) {
                        withAnimation {
                            sheetManager.dismiss()
                            }
                        }
                    }
        }
                .ignoresSafeArea()
    }
}

extension View {
    func popup(with sheetManager: SheetManager) -> some View {
        self.modifier(PopupModifier(sheetManager: sheetManager))
    }
}
