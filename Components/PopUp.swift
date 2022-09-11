//
//  PopUp.swift
//  NPC
//
//  Created by Le Nguyen on 04/09/2022.
//

import SwiftUI

struct PopUp: View {
    
    let config: SheetManager.Config
    let didClose: () -> Void

    var body: some View {
            VStack(spacing: 0) {
                close
                title
                content
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 10)
                    .multilineTextAlignment(.center)
                    .background(background)
                    .transition(.move(edge: .top))
        
        }
}

struct PopUp_Previews: PreviewProvider {
    static var previews: some View {
        PopUp(config: .init(systemName: "xmark", title: "Notification", content: "Podcast added to your list")) {}
            .background(.orange)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}

private extension PopUp {
    var background: some View {
        RoundedCorners(color: .white, tl: 0, tr: 0, bl: 30, br: 30)
            .shadow(color: .black.opacity(0.2), radius: 3)
    }
}

private extension PopUp {
    var close:some View {
        Button {
            didClose()
        } label: {
            Image(systemName:config.systemName)
                .symbolVariant(.circle.fill)
                .font(
                    .system(size:25,
                            weight:.bold,
                            design:.rounded)
                )
                .foregroundColor(.gray.opacity(0.4))
                .padding(5)
        }
    }
    
    var title:some View {
        Text(config.title)
            .font(
                .system(size:30, weight: .bold, design:.rounded)
            ).padding()

    }
    
    var content:some View {
        Text(config.content)
    }
    
}

// MARK: stackoverfl.com/questions/56760335/round-specific-corners-swiftui
struct RoundedCorners: View {
    var color: Color = .blue
    var tl: CGFloat = 0.0
    var tr: CGFloat = 0.0
    var bl: CGFloat = 0.0
    var br: CGFloat = 0.0
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                
                let w = geometry.size.width
                let h = geometry.size.height

                // Make sure we do not exceed the size of the rectangle
                let tr = min(min(self.tr, h/2), w/2)
                let tl = min(min(self.tl, h/2), w/2)
                let bl = min(min(self.bl, h/2), w/2)
                let br = min(min(self.br, h/2), w/2)
                
                path.move(to: CGPoint(x: w / 2.0, y: 0))
                path.addLine(to: CGPoint(x: w - tr, y: 0))
                path.addArc(center: CGPoint(x: w - tr, y: tr), radius: tr, startAngle: Angle(degrees: -90), endAngle: Angle(degrees: 0), clockwise: false)
                path.addLine(to: CGPoint(x: w, y: h - br))
                path.addArc(center: CGPoint(x: w - br, y: h - br), radius: br, startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 90), clockwise: false)
                path.addLine(to: CGPoint(x: bl, y: h))
                path.addArc(center: CGPoint(x: bl, y: h - bl), radius: bl, startAngle: Angle(degrees: 90), endAngle: Angle(degrees: 180), clockwise: false)
                path.addLine(to: CGPoint(x: 0, y: tl))
                path.addArc(center: CGPoint(x: tl, y: tl), radius: tl, startAngle: Angle(degrees: 180), endAngle: Angle(degrees: 270), clockwise: false)
                path.closeSubpath()
            }
            .fill(self.color)
        }
    }
}
