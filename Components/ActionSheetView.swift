//
//  ActionSheet.swift
//  NPC
//
//  Created by Nguyen Huynh Phuong Anh on 12/09/2022.
//

import SwiftUI

struct ActionSheetView<Content: View>: View {

    let content: Content
    let topPadding: CGFloat
    let fixedHeight: Bool
    let bgColor: Color

    init(topPadding: CGFloat = 100, fixedHeight: Bool = false, bgColor: Color = .white, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.topPadding = topPadding
        self.fixedHeight = fixedHeight
        self.bgColor = bgColor
    }

    var body: some View {
        ZStack {
            bgColor.cornerRadius(40)
            VStack {
                Color.black
                    .opacity(0.2)
                    .frame(width: 30, height: 6)
                    .clipShape(Capsule())
                    .padding(.top, 15)
                    .padding(.bottom, 10)

                content
                    .padding(.bottom, 30)
//                    .applyIf(fixedHeight) {
//                        $0.frame(height: UIScreen.main.bounds.height - topPadding)
//                    }
//                    .applyIf(!fixedHeight) {
//                        $0.frame(maxHeight: UIScreen.main.bounds.height - topPadding)
//                    }
            }
        }
        .fixedSize(horizontal: false, vertical: true)
    }
}
