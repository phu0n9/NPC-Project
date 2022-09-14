//
//  ProfileView.swift
//  NPC
//
//  Created by Nguyen Huynh Phuong Anh on 31/08/2022.
//
import SwiftUI

struct ProfileView: View {
    @StateObject var userViewModel = UserViewModel()
    @StateObject var podcastViewModel = PodcastViewModel()
    @State var isPickerShowing = false
    @State var selectedImage: UIImage?
    @State var isSubmit = false
    @State var isFull = true
    @State var alert = false
    @State var updateStatus = ""
    @EnvironmentObject var routerView: RouterView

    var body: some View {
        NavigationView {
            if self.userViewModel.user.favoriteTopics.count != 3 {
                ProgressView("Loading...")
                    .scaleEffect(2)
                    .font(.body)
                    .padding()
                    .navigationBarHidden(true)
            } else {
                ScrollView {
                    VStack(spacing: 16) {
                        
                        if selectedImage != nil {
                            Image(uiImage: selectedImage!)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .clipShape(Circle())
                                .frame(width: 200, height: 200, alignment: .center)
                                .padding()
                                .onTapGesture {
                                    self.isPickerShowing = true
                                }
                        } else {
                            if self.userViewModel.user.profilePic == "" {
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .clipShape(Circle())
                                    .frame(width: 200, height: 200, alignment: .center)
                                    .padding()
                                    .onTapGesture {
                                        self.isPickerShowing = true
                                    }
                            } else {
                                AsyncImage(url: URL(string: self.userViewModel.user.profilePic)) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .clipShape(Circle())
                                        .frame(width: 200, height: 200, alignment: .center)
                                        .padding()
                                        .onTapGesture {
                                            self.isPickerShowing = true
                                        }
                                } placeholder: {
                                    ProgressView()
                                }
                            }
                        }
                        
                        DisableTextComponent(title: Binding.constant("Username"), textValue: Binding.constant(self.userViewModel.user.userName), imageName: Binding.constant("person"))
                        
                        DisableTextComponent(title: Binding.constant("Email"), textValue: Binding.constant(self.userViewModel.user.email), imageName: Binding.constant("envelope"))
                        
                        CategoryCheckbox(fetchCategoryList: self.$podcastViewModel.categories, isFull: self.$isFull, categoryList: self.$userViewModel.user.favoriteTopics)
                        
                        Button {
                            self.handleUpdate()
                        } label: {
                            HStack {
                                Spacer()
                                Text("Update")
                                    .foregroundColor(.white)
                                    .padding(.vertical, 10)
                                    .font(.system(size: 18, weight: .bold))
                                Spacer()
                            }.background(Color(red: 1, green: 0.4902, blue: 0.3216))
                        }
                        .padding(0)
                        .frame(width: 280, height: 50)
                        
                        Button {
                            signOutUser()
                        } label: {
                            HStack {
                                Spacer()
                                Text("Log out")
                                    .foregroundColor(.white)
                                    .padding(.vertical, 10)
                                    .font(.system(size: 18, weight: .bold))
                                Spacer()
                            }.background(.red)
                        }
                        .padding(0)
                        .frame(width: 280, height: 50)
                    }
                }
                .navigationBarHidden(true)
            }
        }
        .sheet(isPresented: $isPickerShowing, onDismiss: nil) {
            ImagePicker(selectedImage: $selectedImage, isPickerShowing: $isPickerShowing)
        }
        .alert(isPresented: self.$alert, content: {
            Alert(title: Text("Status"), message: Text(self.updateStatus))
        })
        .onAppear {
            DispatchQueue.main.async {
                self.userViewModel.fetchUser()
                self.podcastViewModel.fetchCategories()
            }
        }
    }
    
    func handleUpdate() {
        self.alert = true
        if self.userViewModel.user.favoriteTopics.count == 3 {
            DispatchQueue.main.async {
                self.userViewModel.uploadPhoto(selectedImage: selectedImage, categoryList: self.userViewModel.user.favoriteTopics)
                self.updateStatus = "Update successfully"
            }
        } else {
            self.updateStatus = "Update error"
        }
    }
    
    func signOutUser() {
        do {
            try FirebaseManager.shared.auth.signOut()
            print("Successfully sign out")
            self.userViewModel.resetUserDefault()
            withAnimation {
                routerView.currentPage = .login
            }
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
