//
//  FieldComponent.swift
//  NPC
//
//  Created by Nguyen Anh Minh on 02/09/2022.
//

import SwiftUI

struct FieldComponent: View {
    var body: some View {
        VStack {
            Capsule()
                /* #f5f5f5 */
                .foregroundColor(Color(red: 0.9608, green: 0.9608, blue: 0.9608))
                .frame(width: 380, height: 50)
                .padding(0)
                .overlay(
                    HStack {
                        Image(systemName: "envelope")
                            .resizable()
                            .frame(width: 36, height: 24, alignment: .trailing)
                            .offset(x: -100, y: 0)
                        Text("Email ")
                            .offset(x: -80, y: 0)
                    }
                        
                )
                .padding()
            
            Capsule()
                /* #f5f5f5 */
                .foregroundColor(Color(red: 0.9608, green: 0.9608, blue: 0.9608))
                .frame(width: 380, height: 50)
                .padding(0)
                .overlay(
                    HStack {
                        Image(systemName: "lock")
                            .resizable()
                            .frame(width: 20, height: 30, alignment: .trailing)
                            .offset(x: -80, y: 0)
                        Text("Password: ")
                            .offset(x: -60, y: 0)
                    }
                )
        }
    }
}

struct FieldComponent_Previews: PreviewProvider {
    static var previews: some View {
        FieldComponent()
    }
}
