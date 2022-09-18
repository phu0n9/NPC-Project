//
//  DisableTextComponent.swift
//  NPC
//
//  Created by Nguyen Huynh Phuong Anh on 11/09/2022.
//

import SwiftUI

struct DisableTextComponent: View {
    @Binding var title : String
    @Binding var textValue : String
//    @Binding var imageName : String
    
    var body: some View {
        VStack(alignment: .center) {
            Capsule()
            /* #f5f5f5 */
                .foregroundColor(.white)
                .frame(width: 200, height: 40, alignment: .center)
                .padding(0)
                .overlay(
                    HStack {
            
                        TextField(title, text: $textValue)
                            .keyboardType(.emailAddress)
                            .disabled(true)
                            .frame(width: 200, height: 40, alignment: .center)
                    }
                )
                .padding(6)
                .autocapitalization(.none)
        }
    }
}

struct DisableTextComponent_Previews: PreviewProvider {
    static var previews: some View {
        DisableTextComponent(title: Binding.constant("username"), textValue: Binding.constant("Phuong"))
    }
}
