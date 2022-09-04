//
//  PopUpTesting.swift
//  NPC
//
//  Created by Le Nguyen on 04/09/2022.
//

import SwiftUI

struct PopUpTesting: View {
    var body: some View {
        ZStack{
            Color(.orange)
                .ignoresSafeArea()
            Button("Pop up!"){
                
            }
        }.overlay(alignment: .top){
            PopUp()
        }
        .ignoresSafeArea()
        
    }
}

struct PopUpTesting_Previews: PreviewProvider {
    static var previews: some View {
        PopUpTesting()
    }
}
