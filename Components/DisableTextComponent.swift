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
        VStack(alignment: .center){
            Capsule()
            /* #f5f5f5 */
    //            .foregroundColor(Color(red: 0.9608, green: 0.9608, blue: 0.9608))
                .foregroundColor(.white)
    //            .frame(width: 320, height: 40)
                .frame(width: 200, height: 40,alignment: .center)
                .padding(0)
                .overlay(
                    HStack {
    //                    Image(systemName: imageName)
    //                        .resizable()
    //                        .frame(width: 25, height: 20, alignment: .trailing)
    //                        .offset(x: 20, y: 0)
                        
                        TextField(title, text: $textValue)
                            .keyboardType(.emailAddress)
    //                        .offset(x: 40, y: 0)
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
//    static var previews: some View {
//        DisableTextComponent(title: Binding.constant("username"), textValue: Binding.constant("Phuong"), imageName: Binding.constant("person"))
//    }
    static var previews: some View {
        DisableTextComponent(title: Binding.constant("username"), textValue: Binding.constant("Phuong"))
    }
}
