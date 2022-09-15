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
        ZStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 5) {
                    ForEach(self.$fetchCategoryList, id: \.id) { $category in
                        Toggle(category.categories, isOn: $category.checked).toggleStyle(CheckBoxToggleStyle())
                            .font(.system(size: 16, weight: .medium))
                            .padding(10)
                            .disabled(isFull == true && category.checked == false)
                    }
                    .onAppear {
                        DispatchQueue.main.async {
                            if self.categoryList.count == 3 {
                                for i in 0..<self.fetchCategoryList.count {
                                    for j in 0..<self.categoryList.count where self.fetchCategoryList[i].categories == self.categoryList[j] {
                                        self.fetchCategoryList[i].checked = true
                                    }
                                }
                            }
                        }
                    }
                    .onChange(of: self.fetchCategoryList.filter {$0.checked}.count) { value in
                        self.isFull = value >= 3 ? true : false
                        if value == 3 {
                            self.categoryList.removeAll()
                            for category in self.fetchCategoryList.filter({$0.checked == true}) {
                                self.categoryList.append(category.categories)
                            }
                            print(self.categoryList)
                        }
                    }
                }
            }
            .frame(width: UIScreen.main.bounds.width - 70, height: 350, alignment: .center)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color("MainButton").opacity(0.1))
                    .allowsHitTesting(false)
                    .frame(width: UIScreen.main.bounds.width - 70, height: 350)
                    .addBorder(Color("MainButton"), width: 2, cornerRadius: 5)
            )
        }
        .padding(3)
    }
}

struct CategoryCheckbox_Previews: PreviewProvider {
    static var previews: some View {
        CategoryCheckbox(fetchCategoryList: Binding.constant([Categories(categories: "Technology")]), isFull: Binding.constant(false), categoryList: Binding.constant([]))
    }
}
