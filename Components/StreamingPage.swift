//
//  StreamingPageComponent.swift
//  NPC
//
//  Created by Sang Yeob Han  on 11/09/2022.
//

import SwiftUI

struct StreamingPage: View {
    
    @State var showSheet:Bool = false
    
    var body: some View {
            
        Button{
            showSheet.toggle()
        } label: {
            Text("Episode")
        }
        .halfSheet(showsheet: $showSheet){
            ZStack{
                Color.white
                    
        //Mark:: From streamingView.swift
                
                StreamingView()
            }.ignoresSafeArea()
        } onEnd: {
            print("Dismissed")
        }
    }
}

struct StreamingPage_Previews: PreviewProvider {
    static var previews: some View {
        StreamingPage()
    }
}


extension View{
    func halfSheet<SheetView: View>(showsheet: Binding<Bool>,@ViewBuilder sheetView: @escaping ()->SheetView,onEnd: @escaping ()->())->some View{
        return self
            .background(
                HalfSheetHelper(sheetView: sheetView(),showSheet: showsheet,onEnd: onEnd)
            )
    }
}


struct HalfSheetHelper<SheetView: View>: UIViewControllerRepresentable{
    
    var sheetView: SheetView
    @Binding var showSheet: Bool
    var onEnd: ()->()
    
    let controller = UIViewController()
    
//    func makeCoordinator() -> Coordinator {
//
//        return Coordinator(self)
//    }
    
    
    func makeUIViewController(context: Context) -> UIViewController {
        
        controller.view.backgroundColor = .clear
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
        if showSheet{
            
            let sheetController = CustomHostingController(rootView: sheetView)
            
//            sheetController.presentationController?.delegate = context.coordinator
            
            uiViewController.present(sheetController, animated: true){
                
                DispatchQueue.main.async {
                    self.showSheet.toggle()
                }
                
            }
        }
//        }
//        else{
//            uiViewController.dismiss(animated: true)
//        }
    }
    
    class Coorninator: NSObject,UISheetPresentationControllerDelegate{
        
        var parent: HalfSheetHelper
        
        init(parent: HalfSheetHelper){
            self.parent = parent
        }
        
        func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
            parent.showSheet = false
            parent.onEnd()
        }
    }
}

class CustomHostingController<Content: View>: UIHostingController<Content>{
    
    override func viewDidLoad() {
        
        view.backgroundColor = .clear
        if let presentationController = presentationController as? UISheetPresentationController{
          
            presentationController.detents = [
//                .medium(),
                .large()
            ]
         
            presentationController.prefersGrabberVisible = true
        }
    }
}
