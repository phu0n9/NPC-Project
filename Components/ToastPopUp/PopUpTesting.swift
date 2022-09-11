//
//  PopUpTesting.swift
//  NPC
//
//  Created by Le Nguyen on 04/09/2022.
//

import SwiftUI


struct PopUpTesting: View {

    var body: some View {
        ZStack {

            showToast(message: "Updating...", seconds: 1.0)
        }


    }
    

}

struct PopUpTesting_Previews: PreviewProvider {
    static var previews: some View {
        PopUpTesting()
            .environmentObject(SheetManager())
    }
}


extension UIViewController{

func showToast(message : String, seconds: Double){
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.view.backgroundColor = .black
        alert.view.alpha = 0.5
        alert.view.layer.cornerRadius = 15
        self.present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
            alert.dismiss(animated: true)
        }
    }
 }
