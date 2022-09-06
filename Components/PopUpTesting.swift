//
//  PopUpTesting.swift
//  NPC
//
//  Created by Le Nguyen on 04/09/2022.
//

import SwiftUI

struct PopUpTesting: View {
    
    @EnvironmentObject var sheetManager: SheetManager
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        ZStack {
            Color(.orange)
                .ignoresSafeArea()
            
            Button(
                    "Pop up!",
                   action: { self.presentationMode.wrappedValue.dismiss()
                       withAnimation {
                           sheetManager.present(with: .init(systemName:"xmark",
                                                title:"Notification",
                                                            content:"content1"))
                       }
                   }
            )

//            Button("Pop up2!"){
//                    withAnimation{
//                        sheetManager.present(with: .init(systemName:"xmark",
//                                             title:"Notification",
//                                                         content:"content2"))
//                    }
//            }
        }
        .popup(with: sheetManager)
        
    }

}

struct PopUpTesting_Previews: PreviewProvider {
    static var previews: some View {
        PopUpTesting()
            .environmentObject(SheetManager())
    }
}
