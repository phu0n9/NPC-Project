//
//  CategoryCheckbox.swift
//  NPC
//
//  Created by Nguyen Huynh Phuong Anh on 09/09/2022.
//

import SwiftUI

struct CategoryCheckbox: View {
    @Binding var fetchCategoryList: [Categories]
    @Binding var isFull: Bool
    @Binding var categoryList: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            ForEach(self.$fetchCategoryList, id: \.id) { $category in
                    Toggle(category.categories, isOn: $category.checked).toggleStyle(CheckBoxToggleStyle())
                        .font(.system(size: 20, weight: .semibold))
                        .padding()
                        .disabled(isFull == true && category.checked == false)
                }
                .onChange(of: self.fetchCategoryList.filter {$0.checked}.count) { value in
                    self.isFull = value >= 3 ? true : false
                    if value == 3 {
                        self.categoryList.removeAll()
                        for category in self.fetchCategoryList.filter({$0.checked == true}) {
                            self.categoryList.append(category.categories)
                        }
                    }
                }
            
        }.padding()
    }
}

struct CategoryCheckbox_Previews: PreviewProvider {
    static var previews: some View {
        CategoryCheckbox(fetchCategoryList: Binding.constant([Categories(categories: "Technology")]), isFull: Binding.constant(false), categoryList: Binding.constant([]))
    }
}
