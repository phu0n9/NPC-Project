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
    //
    @State var alert = false
    @State var updateStatus = ""
    @EnvironmentObject var routerView: RouterView
    @State var categoryList = [String]()
    
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
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 150, height: 150)
                                .clipShape(Rectangle())
                                .cornerRadius(20)
                                .onTapGesture {
                                    self.isPickerShowing = true
                                }
                                .padding()
                        } else {
                            if self.userViewModel.user.profilePic == "" {
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 150, height: 150)
                                    .clipShape(Rectangle())
                                    .cornerRadius(20)
                                    .onTapGesture {
                                        self.isPickerShowing = true
                                    }
                                    .padding()
                            } else {
                                AsyncImage(url: URL(string: self.userViewModel.user.profilePic)) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 150, height: 150)
                                        .clipShape(Rectangle())
                                        .cornerRadius(20)
                                        .onTapGesture {
                                            self.isPickerShowing = true
                                        }
                                } placeholder: {
                                    ProgressView()
                                }
                                .padding()
                            }
                            
                        }
                        
                        DisableTextComponent(title: Binding.constant("Username"), textValue: Binding.constant(self.userViewModel.user.userName), imageName: Binding.constant("person"))
                        
                        DisableTextComponent(title: Binding.constant("Email"), textValue: Binding.constant(self.userViewModel.user.email), imageName: Binding.constant("envelope"))
                        
                        CategoryCheckbox(fetchCategoryList: self.$podcastViewModel.categories, isFull: self.$isFull, categoryList: self.$categoryList)
                            .onAppear {
                                self.categoryList = self.userViewModel.user.favoriteTopics
                            }
                        
                        Button {
                            self.handleUpdate()
                        } label: {
                            HStack {
                                Spacer()
                                Image(systemName: "arrow.clockwise.circle.fill")
                                    .renderingMode(.template)
                                    .foregroundColor(.white)
                                    .font(.system(size:30,
                                                  weight: .regular,
                                                  design: .default))
                                Text("Update")
                                    .foregroundColor(.white)
                                    .padding(.vertical, 10)
                                    .font(.system(size: 22, weight: .bold))
                                    .cornerRadius(20)
                                Spacer()
                            }.background(Color(red: 1, green: 0.4902, blue: 0.3216))
                        }
                        .padding(0)
                        .frame(width: 280, height: 50)
                        .cornerRadius(50)
                        
                        Button {
                            signOutUser()
                        } label: {
                            HStack {
                                Spacer()
                                Image(systemName: "leaf.fill")
                                    .renderingMode(.template)
                                    .foregroundColor(.white)
                                    .font(.system(size:30,
                                                  weight: .regular,
                                                  design: .default))
                                Text("Log out")
                                    .foregroundColor(.white)
                                    .padding(.vertical, 10)
                                    .font(.system(size: 22, weight: .bold))
                                    
                                Spacer()
                            }.background(.black)
                        }
                        .padding(0)
                        .frame(width: 280, height: 50)
                        .cornerRadius(50)
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
                self.userViewModel.uploadPhoto(selectedImage: selectedImage, categoryList: self.categoryList)
            }
            self.updateStatus = "Update successfully"
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
