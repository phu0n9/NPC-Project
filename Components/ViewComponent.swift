/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2022B
  Assessment: Assignment 3
  Authors:
    Nguyen Huynh Anh Phuong - s3695662
    Le Nguyen - s3777242
    Han Sangyeob - s3821179
    Nguyen Anh Minh - s3911237
  Created  date: 29/08/2022
  Last modified: 18/09/2022
  Acknowledgments: StackOverflow, Youtube, and Mr. Tom Huynh’s slides
*/

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
