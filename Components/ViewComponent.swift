//
//  ViewComponent.swift
//  NPC
//
//  Created by Nguyen Huynh Phuong Anh on 05/09/2022.
//

import SwiftUI

struct ViewComponent<Destination:View>: View {
    var destination: Destination
    var viewTitle: String
    
   var navStyle = UIImageView(image: UIImage(named: "logo"))
    
    var body: some View {
    
        NavigationView {
            HStack {
                destination
                    
            }
            .navigationTitle(self.viewTitle)
        }
    }
}

struct ViewComponent_Previews: PreviewProvider {
    static var previews: some View {
        ViewComponent(destination: TrendingView(), viewTitle: "Trending")
    }
}
