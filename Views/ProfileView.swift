//
//  ProfileView.swift
//  NPC
//
//  Created by Nguyen Huynh Phuong Anh on 31/08/2022.
//
import SwiftUI

struct ProfileView: View {
    @State var shouldShowLogOutOptions = false
    @StateObject var userViewModel : UserViewModel = UserViewModel()
    @State var isPickerShowing = false
    @State var selectedImage: UIImage?
    @State var isSubmit = false
    @State var isUserCurrentlyLoggedOut = false
    @ObservedObject private var vm = UserViewModel()
    @Environment(\.rootPresentationMode) private var rootPresentationMode: Binding<RootPresentationMode>
    
    var body: some View {
        
        NavigationView {
            NavigationLink("", destination: LoginView(), isActive: self.$isUserCurrentlyLoggedOut)
                .isDetailLink(false)
            VStack {
                if selectedImage != nil {
                    Image(uiImage: selectedImage!)
                        .resizable()
                        .frame(width: 200, height: 200, alignment: .center)
                }
                
                Button (action: { self.rootPresentationMode.wrappedValue.dismiss() } )
                            { Text("Pop to root") }
                
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
                        self.userViewModel.updateUser(selectedImage: selectedImage, categoryList: ["Technology", "Music"])
                    }
                }
            }
            .sheet(isPresented: $isPickerShowing, onDismiss: nil) {
                ImagePicker(selectedImage: $selectedImage, isPickerShowing: $isPickerShowing)
        }
        }
        Button (action: { self.rootPresentationMode.wrappedValue.dismiss() } )
                    { Text("Pop to root") }
    }
    
    private func handleSignOut() {
        isUserCurrentlyLoggedOut.toggle()
        try? FirebaseManager.shared.auth.signOut()
    }
    

}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
