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

struct PrefCategoryComponent: View {
    @StateObject var userViewModel : UserViewModel = UserViewModel()
    @StateObject var podcastViewModel = PodcastViewModel()
    
    @State private var isSecured: Bool = true
    @State private var isFull : Bool = false
    @State private var categoryList = [String]()
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                if self.podcastViewModel.categories.isEmpty {
                    Section {
                        ProgressView("Downloading…")
                            .scaleEffect(2)
                            .font(.body)
                    }
                } else {
                    
                    ForEach(self.$podcastViewModel.categories, id: \.id) { $category in
                        // MARK: solution 1
                        Toggle(category.categories, isOn: $category.checked).toggleStyle(CheckBoxToggleStyle())
                            .font(.system(size: 20, weight: .semibold))
                            .padding()
                            .disabled(isFull == true && category.checked == false)
                        
                    }
                    .onChange(of: self.podcastViewModel.categories.filter {$0.checked}.count) { value in
                        self.isFull = value >= 3 ? true : false
                        if value == 3 {
                            self.categoryList.removeAll()
                            for category in self.podcastViewModel.categories.filter({$0.checked == true}) {
                                self.categoryList.append(category.categories)
                            }
                        }
                    }.frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                }
                
            }.padding(1.0)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .fill(Color.orange.opacity(0.05))
                        .allowsHitTesting(false)
                        .frame(width: 356, height: 2250)
                        .addBorder(Color.orange, width: 2, cornerRadius: 5)
                )
        }.frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
    }
}

struct PrefCategoryComponent_Previews: PreviewProvider {
    static var previews: some View {
        PrefCategoryComponent()
    }
}
