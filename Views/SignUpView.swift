//
//  SignUpView.swift
//  NPC
//
//  Created by Nguyen Huynh Phuong Anh on 31/08/2022.
//

import SwiftUI

struct SignUpView: View {
    @StateObject var userViewModel : UserViewModel = UserViewModel()
    @State var isPickerShowing = false
    @State var selectedImage: UIImage?
    @State var isSubmit = false
    
    var body: some View {
        VStack {
            if selectedImage != nil {
                Image(uiImage: selectedImage!)
                    .resizable()
                    .frame(width: 200, height: 200, alignment: .center)
            }
            
            Button("Image") {
                isPickerShowing = true
            }
            
            TextField("username", text: Binding.constant(userViewModel.user.userName))
            TextField("email", text: Binding.constant(userViewModel.user.userName))
            
            Button("Submit") {
                self.isSubmit.toggle()
            }
            
            Image(uiImage: self.userViewModel.image)
                .resizable()
                .frame(width: 200, height: 200, alignment: .center)
            
            .onChange(of: isSubmit) { value in
                if value {
                    if selectedImage != nil {
                        self.userViewModel.uploadPhoto(selectedImage: selectedImage)
                    }
                }
            }
        }
        .sheet(isPresented: $isPickerShowing, onDismiss: nil) {
            ImagePicker(selectedImage: $selectedImage, isPickerShowing: $isPickerShowing)
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
