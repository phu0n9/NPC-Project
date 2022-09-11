//
//  ToastPopUp.swift
//  NPC
//
//  Created by Sang Yeob Han  on 11/09/2022.
//

import SwiftUI
import SimpleToast

struct ToastPopUp: View{
    
    @State private var showToast = false
    @State private var value = 0
    var message: String
    
    private let toastOptions = SimpleToastOptions(
        alignment: .top,
        hideAfter: 2,
        backdrop: .black.opacity(0.2),
        animation: .default,
        modifierType: .slide
    )
    
    
    var body: some View{
    
            Button(action: {
                showToast.toggle()
             },
                   label: {
                Image(systemName: "heart.fill")
                    .renderingMode(.template)
                    .foregroundColor(.orange)
                    .frame(width:20, height: 20, alignment: .leading)
                    .padding()
                    .simpleToast(isPresented: $showToast, options: toastOptions, onDismiss: {
                            value += 1
                                }) {
                    
                                    HStack{
                                        Text(self.message)
                                        }
                                        .padding(20)
                                        .background(Color.orange)
                                        .foregroundColor(Color.white)
                                        .cornerRadius(15)
                                    }
                }
            )

    }
    
}


struct ContentView_previews: PreviewProvider {
    static var previews: some View{
        ToastPopUp(message:"Episode added to my list")
    }
}
